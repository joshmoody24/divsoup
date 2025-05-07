defmodule Divsoup.Analyzer.JobService do
  @moduledoc """
  The Analyzer context handles website analysis jobs and their lifecycle.
  """
  import Ecto.Query
  alias Divsoup.Repo
  alias Divsoup.Analyzer.{Job, JobQueue}

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
        IO.puts("Created job with ID: #{job.id}")
        
        # Enqueue the job for processing
        JobQueue.enqueue(job)
        
        # Return the job
        {:ok, job}
        
      error ->
        error
    end
  end

  @doc """
  Gets a job by ID.
  """
  def get_job(id) do
    case Repo.get(Job, id) do
      nil ->
        {:error, "Job not found"}

      job ->
        {:ok, job}
    end
  end

  @doc """
  Mark a job as in-progress by updating its timestamp and any partial data
  """
  def mark_job_in_progress(id, partial_data \\ nil) do
    job = Repo.get(Job, id)

    case job do
      nil ->
        {:error, "Job not found"}

      _ ->
        job
        |> Job.changeset(%{
          started_at: DateTime.utc_now(),
          data: partial_data
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
        
        job
        |> Job.changeset(%{
          started_at: started_at,
          data: results,
          finished_at: DateTime.utc_now()
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
        
        job
        |> Job.changeset(%{
          started_at: started_at,
          errors: error_data,
          finished_at: DateTime.utc_now()
        })
        |> Repo.update()
    end
  end

  @doc """
  Gets a list of jobs by inferred status with the specified ordering.
  """
  def get_jobs_by_status(status, limit, order_by_direction \\ :desc) do
    query = case status do
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
        # Jobs with finished_at time and data but no errors
        from j in Job,
          where: not is_nil(j.finished_at) and not is_nil(j.data) and is_nil(j.errors),
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
        where: not is_nil(j.started_at) and is_nil(j.finished_at) and j.updated_at < ^timeout_threshold,
        order_by: [asc: j.started_at]
    
    case Repo.all(query) do
      [] -> {:error, "No stuck jobs found"}
      jobs -> {:ok, jobs}
    end
  end
end