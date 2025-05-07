defmodule Divdump.JobService do
  @moduledoc """
  The Analyzer context handles website analysis jobs and their lifecycle.
  """
  import Ecto.Query
  alias Divdump.Repo
  alias Divdump.Analyzer.{Job, JobEvent}

  @doc """
  Creates a new analysis job with an initial pending status.
  """
  def create_job(url) do
    # transaction
    Repo.transaction(fn ->
      # create a job
      {:ok, job} =
        %Job{}
        |> Job.changeset(%{url: url})
        |> Repo.insert()

      # print job id
      IO.puts("Created job with ID: #{job.id}")

      # also create a job event
      {:ok, _event} =
        %JobEvent{}
        |> JobEvent.changeset(%{
          job_id: job.id,
          status: :pending,
          data: nil,
          timestamp: DateTime.utc_now()
        })
        |> Repo.insert()

      # Return the job from the transaction
      job
    end)
  end

  @doc """
  Gets a job by ID with its most recent event.
  """
  def get_job(id) do
    # join with job events, order by timestamp desc, return the latest job + most recent event
    query =
      from j in Job,
        join: je in JobEvent,
        on: j.id == je.job_id,
        where: j.id == ^id,
        order_by: [desc: je.timestamp],
        limit: 1,
        select: {j, je}

    case Repo.one(query) do
      nil ->
        {:error, "Job not found"}

      {job, job_event} ->
        {:ok, %{job: job, job_event: job_event}}
    end
  end

  @doc """
  Adds a new status event to an existing job.
  Returns {:ok, job_event} on success or {:error, reason} on failure.
  """
  def append_job_status(id, status, data \\ nil) do
    job = Repo.get(Job, id)

    case job do
      nil ->
        {:error, "Job not found"}

      _ ->
        %JobEvent{}
        |> JobEvent.changeset(%{
          job_id: job.id,
          status: status,
          data: data,
          timestamp: DateTime.utc_now()
        })
        |> Repo.insert()
    end
  end

  @doc """
  Gets a list of jobs by status with the specified ordering.
  Only returns jobs where the LATEST status matches the requested status.
  """
  def get_jobs_by_status(status, limit, order_by_direction \\ :desc) do
    # Get latest event for each job
    latest_events = 
      from(je in JobEvent,
        distinct: [je.job_id],
        order_by: [desc: je.timestamp, desc: je.id],
        select: %{job_id: je.job_id, event_id: je.id})
    
    # Join with jobs and filter by status
    query =
      from(j in Job,
        join: je in JobEvent, on: je.job_id == j.id,
        join: le in subquery(latest_events), on: je.id == le.event_id,
        where: je.status == ^status,
        select: {j, je},
        order_by: [{^order_by_direction, je.timestamp}],
        limit: ^limit)
    
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
    # Get the latest event ID for each job
    latest_events_query = 
      from(je in JobEvent,
        group_by: je.job_id,
        select: %{
          job_id: je.job_id, 
          latest_id: fragment("MAX(?)", je.id)
        })
      
    # Find jobs with pending status in their latest event
    query = 
      from(j in Job,
        join: je in JobEvent, on: je.job_id == j.id,
        join: le in subquery(latest_events_query), on: je.job_id == le.job_id and je.id == le.latest_id,
        where: je.status == :pending,
        order_by: [asc: j.inserted_at],
        limit: 1,
        select: j)
    
    case Repo.one(query) do
      nil -> {:error, "No pending jobs found"}
      job -> {:ok, job}
    end
  end

  @doc """
  Claims a pending job for processing.
  Uses a transaction-based approach for SQLite since it doesn't support row-level locking.

  Returns {:ok, job} if a job was claimed, or {:error, reason} if no jobs
  were availabe or an error occurred.
  """
  def claim_next_pending_job do
    Repo.transaction(fn ->
      # 1. Find the oldest pending job
      case get_oldest_pending_job() do
        {:error, _reason} ->
          Repo.rollback("No pending jobs available")
          
        {:ok, job} ->
          # 2. Double-check job is still pending before proceeding
          latest_status_query =
            from je in JobEvent,
            where: je.job_id == ^job.id,
            order_by: [desc: je.timestamp],
            limit: 1,
            select: je.status
          
          case Repo.one(latest_status_query) do
            :pending ->
              # Job is still pending, we can claim it
              {:ok, _event} =
                %JobEvent{}
                |> JobEvent.changeset(%{
                  job_id: job.id,
                  status: :in_progress,
                  data: nil,
                  timestamp: DateTime.utc_now()
                })
                |> Repo.insert()
                
              # Return the job if successful
              job
              
            other_status ->
              # Job was already claimed by another worker
              Repo.rollback("Job #{job.id} status changed to #{other_status} by another worker")
          end
      end
    end)
  end
end
