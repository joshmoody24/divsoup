defmodule Divsoup.Analyzer.JobService do
  @moduledoc """
  The Analyzer context handles website analysis jobs and their lifecycle.
  """
  import Ecto.Query
  alias Divsoup.Repo
  alias Divsoup.Analyzer.{Job, JobQueue}
  alias Divsoup.AchievementList
  require Logger
  
  # Cache for job metrics (achievements)
  @job_cache_ttl 900 # 15 minutes in seconds
  @cache_table :job_metrics_cache

  # Initialize the cache table when the module is loaded
  def init_cache do
    :ets.new(@cache_table, [:set, :public, :named_table])
    :ok
  end

  # Helper to get from cache
  defp get_from_cache(key) do
    case :ets.lookup(@cache_table, key) do
      [{^key, value, timestamp}] ->
        now = System.system_time(:second)
        if now - timestamp < @job_cache_ttl do
          {:ok, value}
        else
          # Cache entry expired, remove it
          :ets.delete(@cache_table, key)
          :not_found
        end
      [] -> :not_found
    end
  end

  # Helper to store in cache
  defp store_in_cache(key, value) do
    timestamp = System.system_time(:second)
    :ets.insert(@cache_table, {key, value, timestamp})
    :ok
  end

  @doc """
  Creates a new analysis job and enqueues it for processing.
  """
  def create_job(url) do
    # Create an initial job record
    job_result =
      %Job{}
      |> Job.changeset(%{url: url})
      |> Repo.insert()

    case job_result do
      {:ok, job} ->
        Logger.info("Created job with ID: #{job.id}")

        # Enqueue the job for processing
        JobQueue.enqueue(job)

        # Return the job
        {:ok, job}

      error ->
        error
    end
  end

  @doc """
  Gets a job by ID. Handles both standard UUIDs and hyphenless UUIDs.
  """
  def get_job(id) do
    # Convert hyphenless UUID to standard format if needed
    uuid = hyphenless_to_uuid(id)
    
    case Repo.get(Job, uuid) do
      nil ->
        {:error, "Job not found"}

      job ->
        {:ok, job}
    end
  end
  
  @doc """
  Converts a hyphenless UUID string to a standard UUID with hyphens.
  """
  def hyphenless_to_uuid(id) when byte_size(id) == 32 do
    <<p1::binary-size(8), p2::binary-size(4), p3::binary-size(4), p4::binary-size(4), p5::binary-size(12)>> = id
    "#{p1}-#{p2}-#{p3}-#{p4}-#{p5}"
  end
  
  def hyphenless_to_uuid(id), do: id

  @doc """
  Extracts metrics and achievements from a job.
  """
  def get_job_with_metrics(job_id) do
    case get_job(job_id) do
      {:ok, job} ->
        # Only use cache for completed jobs
        if Job.status(job) == :completed do
          # Try to get results from cache first
          cache_key = "job_metrics:#{job_id}"
          case get_from_cache(cache_key) do
            {:ok, cached_results} ->
              Logger.info("Using cached results for completed job #{job_id}")
              {:ok, cached_results}
          
          :not_found ->
            # Process and cache data for completed jobs
            process_job_achievements(job, job_id)
          end
        else
          # For non-completed jobs, always process without caching
          Logger.info("Processing non-completed job #{job_id} without caching")
          process_job_achievements(job, job_id)
        end

      error ->
        error
    end
  end
  
  # Helper function to process job achievements and optionally cache them
  defp process_job_achievements(job, job_id) do
    cache_key = "job_metrics:#{job_id}"
    
    case job.html_url do
      url when is_binary(url) ->
        with {:ok, 200, _headers, ref} = :hackney.get(url),
             {:ok, body} = :hackney.body(ref),
             {:ok, parsed_html} = Floki.parse_document(body) do
          Logger.info("Parsed HTML successfully for job #{job_id}")

          achievements =
            AchievementList.all()
            |> Enum.map(fn achievement ->
              %{
                achievement: achievement.achievement(),
                fulfills_criteria: Enum.empty?(achievement.evaluate(parsed_html, body))
              }
            end)
            |> Enum.filter(fn result -> result.fulfills_criteria end)
            |> Enum.map(fn result -> result.achievement end)

          results = %{
            job: job,
            achievements: achievements
          }
          
          # Store in cache only for completed jobs
          if Job.status(job) == :completed do
            Logger.info("Caching results for completed job #{job_id}")
            store_in_cache(cache_key, results)
          end
          
          {:ok, results}
        end

      nil ->
        results = %{job: job, achievements: []}
        # Only cache if job is completed
        if Job.status(job) == :completed do
          store_in_cache(cache_key, results)
        end
        {:ok, results}
    end
  end

  @doc """
  Mark a job as in-progress by updating its timestamp
  """
  def mark_job_in_progress(id) do
    job = Repo.get(Job, id)

    case job do
      nil ->
        {:error, "Job not found"}

      _ ->
        job
        |> Job.changeset(%{
          started_at: DateTime.utc_now()
        })
        |> Repo.update()
    end
  end

  @doc """
  Mark a job as complete with its results
  """
  def complete_job(id, results) do
    job = Repo.get(Job, id)

    case job do
      nil ->
        {:error, "Job not found"}

      _ ->
        # Ensure started_at is set if not already
        started_at = if is_nil(job.started_at), do: DateTime.utc_now(), else: job.started_at

        # Invalidate any cached data for this job
        # We'll re-cache on next request after it's completed
        cache_key = "job_metrics:#{id}"
        Logger.info("Invalidating cache for job #{id} on completion")
        :ets.delete(@cache_table, cache_key)

        worker_id = job.claimed_by || "unknown"
        Logger.info("Worker #{worker_id} completed job #{id}")

        job
        |> Job.changeset(%{
          started_at: started_at,
          html_url: results.s3_html_url,
          screenshot_url: results.s3_screenshot_url,
          pdf_url: results.s3_pdf_url,
          finished_at: DateTime.utc_now(),
          # We keep claimed_by/claimed_at to know which worker completed the job
          # but clear errors and retry_count since the job completed successfully
          errors: nil,
          retry_count: 0
        })
        |> Repo.update()
    end
  end

  @doc """
  Mark a job as failed with error details
  """
  def fail_job(id, error_data) do
    job = Repo.get(Job, id)

    case job do
      nil ->
        {:error, "Job not found"}

      _ ->
        # Ensure started_at is set if not already
        started_at = if is_nil(job.started_at), do: DateTime.utc_now(), else: job.started_at
        
        # Increment retry count if not already set
        retry_count = (job.retry_count || 0) + 1

        # Invalidate any cached data for this job
        cache_key = "job_metrics:#{id}"
        Logger.info("Invalidating cache for failed job #{id}")
        :ets.delete(@cache_table, cache_key)
        
        # Clear the claimed_by field so job can be picked up again if retries remain
        result = job
        |> Job.changeset(%{
          started_at: started_at,
          errors: error_data,
          finished_at: DateTime.utc_now(),
          retry_count: retry_count,
          claimed_by: nil,
          claimed_at: nil
        })
        |> Repo.update()
        
        case result do
          {:ok, updated_job} -> 
            Logger.info("Job #{id} failed (attempt #{retry_count}/#{updated_job.max_retries})")
            {:ok, updated_job}
          error -> error
        end
    end
  end

  @doc """
  Gets a list of jobs by inferred status with the specified ordering.
  """
  def get_jobs_by_status(status, limit, order_by_direction \\ :desc) do
    query =
      case status do
        :pending ->
          # Jobs with no started_at time
          from j in Job,
            where: is_nil(j.started_at),
            order_by: [{^order_by_direction, j.inserted_at}],
            limit: ^limit

        :in_progress ->
          # Jobs with started_at but no finished_at time
          from j in Job,
            where: not is_nil(j.started_at) and is_nil(j.finished_at),
            order_by: [{^order_by_direction, j.inserted_at}],
            limit: ^limit

        :completed ->
          # Jobs with finished_at time, HTML and screenshot URLs (PDF is optional), but no errors
          from j in Job,
            where:
              not is_nil(j.finished_at) and not is_nil(j.html_url) and
                not is_nil(j.screenshot_url) and is_nil(j.errors),
            order_by: [{^order_by_direction, j.inserted_at}],
            limit: ^limit

        :failed ->
          # Jobs with finished_at time and errors
          from j in Job,
            where: not is_nil(j.finished_at) and not is_nil(j.errors),
            order_by: [{^order_by_direction, j.inserted_at}],
            limit: ^limit
      end

    case Repo.all(query) do
      [] -> {:error, "No jobs found"}
      jobs -> {:ok, jobs}
    end
  end

  @doc """
  Gets the oldest pending job.
  Returns {:ok, job} if found, or {:error, reason} if no pending job exists.
  """
  def get_oldest_pending_job do
    # Find jobs with pending status (no started_at time)
    query =
      from j in Job,
        where: is_nil(j.started_at),
        order_by: [asc: j.inserted_at],
        limit: 1

    case Repo.one(query) do
      nil -> {:error, "No pending jobs found"}
      job -> {:ok, job}
    end
  end

  @doc """
  Gets jobs that appear to be stuck in the in-progress state.
  This can happen if a worker crashes before completing a job.

  timeout_minutes specifies how long a job can be in_progress before
  it's considered stuck.
  """
  def get_stuck_jobs(timeout_minutes \\ 30) do
    timeout_threshold = DateTime.utc_now() |> DateTime.add(-timeout_minutes * 60)

    # Find jobs with started_at but no finished_at that haven't been updated recently
    query =
      from j in Job,
        where:
          not is_nil(j.started_at) and is_nil(j.finished_at) and j.updated_at < ^timeout_threshold,
        order_by: [asc: j.started_at]

    case Repo.all(query) do
      [] -> {:error, "No stuck jobs found"}
      jobs -> {:ok, jobs}
    end
  end
end
