defmodule Divsoup.Analyzer.Worker do
  @moduledoc """
  GenServer for processing website analysis jobs asynchronously.
  This worker polls for pending jobs and processes them one at a time.
  """
  use GenServer
  require Logger
  alias Divsoup.Analyzer.{JobService, JobQueue, Browser, S3Storage}

  # Client API

  @doc """
  Starts the worker process.
  
  ## Options
  
  * `:name` - The name to register the process under
  * `:worker_id` - A unique identifier for this worker (used in job claims)
  * `:poll_interval` - How often to poll for new jobs in milliseconds
  """
  def start_link(opts \\ []) do
    # Extract name from options or use module name as default
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @doc """
  Manually triggers job processing (useful for testing).
  """
  def process_next(server \\ __MODULE__) do
    GenServer.cast(server, :process_next)
  end

  # Server Callbacks

  @impl true
  def init(opts) do
    # Extract poll interval from options or use default
    poll_interval = Keyword.get(opts, :poll_interval, 5_000)
    
    # Extract or generate a worker ID
    worker_id = Keyword.get(opts, :worker_id, "worker_#{:rand.uniform(1000000)}")
    
    Logger.info("Starting worker #{worker_id} with poll interval #{poll_interval}ms")

    # Schedule first poll
    send(self(), :poll)

    # Initialize state with poll_interval and worker_id
    {:ok, %{poll_interval: poll_interval, worker_id: worker_id}}
  end

  @impl true
  def handle_info(:poll, state) do
    # Try to claim a job from the JobQueue with this worker's ID
    case JobQueue.claim_job(state.worker_id) do
      {:ok, job} ->
        Logger.info("Worker #{state.worker_id} claimed job #{job.id} for processing")
        server_pid = self()

        Task.start(fn ->
          process_job(job, state.worker_id)
          send(server_pid, :poll)
        end)

      {:error, :no_jobs} ->
        Logger.debug("No jobs available for worker #{state.worker_id}")
        Process.send_after(self(), :poll, state.poll_interval)
        
      {:error, reason} ->
        Logger.warning("Worker #{state.worker_id} failed to claim job: #{inspect(reason)}")
        Process.send_after(self(), :poll, state.poll_interval)
    end

    {:noreply, state}
  end

  @impl true
  def handle_cast(:process_next, state) do
    send(self(), :poll)
    {:noreply, state}
  end

  # Private Helper Functions

  defp process_job(job, worker_id) do
    # Log start time for performance tracking
    start_time = System.monotonic_time(:millisecond)
    Logger.info("Worker #{worker_id} starting analysis for job #{job.id}, URL: #{job.url}")

    try do
      results = analyze_website(job.url)
      JobService.complete_job(job.id, results)

      # Log completion
      elapsed = System.monotonic_time(:millisecond) - start_time
      Logger.info("Worker #{worker_id} successfully completed job #{job.id} in #{elapsed}ms")
    rescue
      e ->
        # Get stacktrace for better error reporting
        stacktrace = __STACKTRACE__ |> Exception.format_stacktrace()

        # Record job failure with error details
        error_data = %{
          error: Exception.message(e),
          stacktrace: stacktrace,
          worker_id: worker_id
        }

        # Try to increment retry count and potentially retry the job
        case JobService.fail_job(job.id, error_data) do
          {:ok, updated_job} ->
            if updated_job.retry_count < updated_job.max_retries do
              Logger.warning("Worker #{worker_id} will retry job #{job.id} (attempt #{updated_job.retry_count + 1})")
              # The job will be picked up again by a worker (possibly this one) after a delay
            else
              Logger.error("Worker #{worker_id} failed job #{job.id} permanently after #{updated_job.retry_count} attempts")
            end
          
          error ->
            Logger.error("Worker #{worker_id} couldn't update job #{job.id} failure status: #{inspect(error)}")
        end

        elapsed = System.monotonic_time(:millisecond) - start_time

        Logger.error(
          "Worker #{worker_id} failed job #{job.id} after #{elapsed}ms: #{Exception.message(e)}\n#{stacktrace}"
        )
    end
  end

  defp analyze_website(url) do
    with {:ok, browser_result} <- Browser.analyze_website(url),
         {:ok, s3_result} <- S3Storage.upload_analysis_files(
           browser_result.html_path,
           browser_result.screenshot_path,
           browser_result.pdf_path,
           url,
           browser_result.timestamp
         ) do
      
      # Return results with both local paths and S3 URLs
      %{
        url: url,
        timestamp: browser_result.timestamp,
        meta: %{
          title: "HTML Retrieved", 
          has_viewport: false,
          responsive: false,
          load_time_ms: 0
        },
        html_path: browser_result.html_path,
        screenshot_path: browser_result.screenshot_path,
        pdf_path: browser_result.pdf_path,
        s3_html_url: s3_result.html_url,
        s3_screenshot_url: s3_result.screenshot_url,
        s3_pdf_url: s3_result.pdf_url
      }
    else
      {:error, reason} ->
        # If any step fails, log and raise an error to trigger job failure
        Logger.error("Website analysis failed: #{reason}")
        raise "Website analysis failed: #{reason}"
    end
  end
end

