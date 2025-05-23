defmodule Divsoup.Analyzer.JobQueue do
  @moduledoc """
  Database-based job queue with thread safety for parallel processing.
  Uses the analysis_jobs table with row-level locking to ensure jobs are only processed once.
  """
  use GenServer
  require Logger
  import Ecto.Query
  alias Divsoup.Repo
  alias Divsoup.Analyzer.Job

  # Client API
  # ----------

  @doc """
  Starts the job queue manager.
  """
  def start_link(opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @doc """
  Enqueues a job for processing.
  Simply stores it in the database with pending status.
  """
  def enqueue(_server \\ __MODULE__, job) do
    Logger.info("Enqueuing job #{job.id} for processing")
    # The job is already saved to the database, so it's automatically in the queue
    {:ok, job}
  end

  @doc """
  Claims an unclaimed job for the specified worker.
  This is thread-safe across multiple workers using database transactions.
  
  Returns:
  - {:ok, job} if a job was successfully claimed
  - {:error, :no_jobs} if no unclaimed jobs are available
  - {:error, reason} if an error occurred
  """
  def claim_job(worker_id) do
    now = DateTime.utc_now()
    
    # Check which adapter we're using
    adapter = get_db_adapter()
    
    if adapter == :sqlite do
      # SQLite version (without row-level locking)
      claim_job_sqlite(worker_id, now)
    else
      # PostgreSQL version (with row-level locking)
      claim_job_postgres(worker_id, now)
    end
  end
  
  # Get the current database adapter
  defp get_db_adapter do
    # Check the config for the adapter
    case Application.get_env(:divsoup, Divsoup.Repo)[:adapter] do
      Ecto.Adapters.SQLite3 -> :sqlite
      Ecto.Adapters.Postgres -> :postgres
      _ -> :postgres # Default to postgres
    end
  end
  
  # SQLite implementation (uses basic transactions without row locks)
  defp claim_job_sqlite(worker_id, now) do
    # Use a transaction to ensure atomicity
    Repo.transaction(fn ->
      # Find the oldest unclaimed job
      query =
        from j in Job,
          where: is_nil(j.claimed_by) and is_nil(j.started_at),
          order_by: [asc: j.inserted_at],
          limit: 1
          
      case Repo.one(query) do
        nil ->
          # Check for jobs that need to be retried
          retry_query =
            from j in Job,
              where: not is_nil(j.errors) and j.retry_count < j.max_retries and is_nil(j.claimed_by),
              order_by: [asc: j.updated_at],
              limit: 1
              
          case Repo.one(retry_query) do
            nil -> 
              # No jobs to retry either
              Repo.rollback(:no_jobs)
              
            retry_job ->
              # Re-check that it's still unclaimed to prevent race conditions
              latest_job = Repo.get(Job, retry_job.id)
              
              if is_nil(latest_job.claimed_by) do
                # Claim this job for retry
                latest_job
                |> Job.changeset(%{
                  claimed_by: worker_id,
                  claimed_at: now,
                  started_at: now,
                  retry_count: latest_job.retry_count + 1,
                  errors: nil # Clear previous errors for the retry
                })
                |> Repo.update!()
              else
                # Another worker claimed it between our select and update
                Repo.rollback(:job_claimed_by_another_worker)
              end
          end
          
        job ->
          # Re-check that it's still unclaimed to prevent race conditions
          latest_job = Repo.get(Job, job.id)
          
          if is_nil(latest_job.claimed_by) do
            # Claim the job for this worker
            latest_job
            |> Job.changeset(%{
              claimed_by: worker_id,
              claimed_at: now,
              started_at: now
            })
            |> Repo.update!()
          else
            # Another worker claimed it between our select and update
            Repo.rollback(:job_claimed_by_another_worker)
          end
      end
    end)
    |> case do
      {:ok, job} -> 
        Logger.info("Worker #{worker_id} claimed job #{job.id}")
        {:ok, job}
      {:error, :no_jobs} -> 
        {:error, :no_jobs}
      {:error, :job_claimed_by_another_worker} ->
        # Try again immediately with a recursive call
        claim_job_sqlite(worker_id, now)
      {:error, reason} -> 
        Logger.error("Error claiming job: #{inspect(reason)}")
        {:error, reason}
    end
  end
  
  # PostgreSQL implementation (uses row-level locking)
  defp claim_job_postgres(worker_id, now) do
    # Use a transaction to ensure thread safety
    Repo.transaction(fn ->
      # Find the oldest unclaimed job, using FOR UPDATE to lock the row
      query =
        from j in Job,
          where: is_nil(j.claimed_by) and is_nil(j.started_at),
          order_by: [asc: j.inserted_at],
          limit: 1,
          lock: "FOR UPDATE SKIP LOCKED"
          
      case Repo.one(query) do
        nil ->
          # Check for jobs that need to be retried
          retry_query =
            from j in Job,
              where: not is_nil(j.errors) and j.retry_count < j.max_retries and is_nil(j.claimed_by),
              order_by: [asc: j.updated_at],
              limit: 1,
              lock: "FOR UPDATE SKIP LOCKED"
              
          case Repo.one(retry_query) do
            nil -> 
              # No jobs to retry either
              Repo.rollback(:no_jobs)
              
            retry_job ->
              # Claim this job for retry
              retry_job
              |> Job.changeset(%{
                claimed_by: worker_id,
                claimed_at: now,
                started_at: now,
                retry_count: retry_job.retry_count + 1,
                errors: nil # Clear previous errors for the retry
              })
              |> Repo.update!()
          end
          
        job ->
          # Claim the job for this worker
          job
          |> Job.changeset(%{
            claimed_by: worker_id,
            claimed_at: now,
            started_at: now
          })
          |> Repo.update!()
      end
    end)
    |> case do
      {:ok, job} -> 
        Logger.info("Worker #{worker_id} claimed job #{job.id}")
        {:ok, job}
      {:error, :no_jobs} -> 
        {:error, :no_jobs}
      {:error, reason} -> 
        Logger.error("Error claiming job: #{inspect(reason)}")
        {:error, reason}
    end
  end

  @doc """
  Returns the current queue length (unclaimed jobs).
  """
  def queue_length(_server \\ __MODULE__) do
    Repo.aggregate(
      from(j in Job, where: is_nil(j.claimed_by) and is_nil(j.started_at)),
      :count
    )
  end

  @doc """
  Returns count of jobs in progress.
  """
  def jobs_in_progress(_server \\ __MODULE__) do
    Repo.aggregate(
      from(j in Job, 
        where: not is_nil(j.claimed_by) and 
               not is_nil(j.started_at) and 
               is_nil(j.finished_at)),
      :count
    )
  end

  # Server Callbacks
  # ---------------

  @impl true
  def init(_opts) do
    # No need to maintain state since we use the database
    {:ok, %{}}
  end

  # Handle old interface for backward compatibility - just delegates to claim_job
  @impl true
  def handle_call(:dequeue, _from, state) do
    case claim_job("legacy_worker") do
      {:ok, job} -> {:reply, {:ok, job}, state}
      {:error, :no_jobs} -> {:reply, {:error, :empty}, state}
      {:error, _reason} -> {:reply, {:error, :empty}, state}
    end
  end

  @impl true
  def handle_call(:queue_length, _from, state) do
    {:reply, queue_length(), state}
  end
end

