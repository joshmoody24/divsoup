defmodule Divsoup.Analyzer.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "analysis_jobs" do
    field :url, :string
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime
    field :html_url, :string
    field :screenshot_url, :string
    field :pdf_url, :string
    field :errors, :map

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:url, :started_at, :finished_at, :html_url, :screenshot_url, :pdf_url, :errors])
    |> validate_required([:url])
  end
  
  @doc """
  Helper function to infer the status of the job based on its fields.
  
  Status rules:
  - created_at: When the job was created (Ecto inserted_at)
  - started_at: When processing began
  - finished_at: When processing completed

  Status flow:
  1. Job created → inserted_at set, started_at nil, finished_at nil → :pending
  2. Processing begins → started_at set, finished_at nil → :in_progress
  3a. Success → finished_at set, html_url & screenshot_url populated → :completed  
  3b. Failure → finished_at set, errors populated → :failed
  """
  def status(job) do
    cond do
      # Pending: No start time
      is_nil(job.started_at) -> :pending
      
      # In Progress: Has start time but no finish time
      not is_nil(job.started_at) && is_nil(job.finished_at) -> :in_progress
      
      # Completed: Has finish time and required URLs (HTML and screenshot are required, PDF is optional)
      not is_nil(job.finished_at) && not is_nil(job.html_url) && not is_nil(job.screenshot_url) && is_nil(job.errors) -> :completed
      
      # Failed: Has finish time and errors
      not is_nil(job.finished_at) && not is_nil(job.errors) -> :failed
      
      # Default (Should never happen)
      true -> :unknown
    end
  end
  
  @doc """
  Returns the duration of job processing in seconds, or nil if the job hasn't completed.
  If the job is in progress, returns the elapsed time since started_at.
  """
  def duration(job) do
    cond do
      is_nil(job.started_at) -> nil
      
      not is_nil(job.finished_at) -> 
        DateTime.diff(job.finished_at, job.started_at)
      
      true -> 
        # In progress, get elapsed time
        DateTime.diff(DateTime.utc_now(), job.started_at)
    end
  end
end
