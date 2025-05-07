defmodule Divsoup.Analyzer.Worker do
  @moduledoc """
  GenServer for processing website analysis jobs asynchronously.
  This worker polls for pending jobs and processes them one at a time.
  """
  use GenServer
  require Logger
  alias Divsoup.Analyzer.{JobService, JobQueue}

  # Client API
  # ----------

  @doc """
  Starts the worker process.
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
  # ---------------

  @impl true
  def init(opts) do
    # Extract poll interval from options or use default
    poll_interval = Keyword.get(opts, :poll_interval, 5_000)
    
    # Schedule first poll
    send(self(), :poll)
    
    # Initialize state with just poll_interval
    {:ok, %{poll_interval: poll_interval}}
  end

  @impl true
  def handle_info(:poll, state) do
    # Try to dequeue a job from the JobQueue
    case JobQueue.dequeue() do
      {:ok, job} ->
        Logger.info("Worker dequeued job #{job.id} for processing")
        
        # Mark the job as in_progress (implied by having data or errors but no finished_at)
        JobService.mark_job_in_progress(job.id)
        
        # Get the server's PID
        server_pid = self()
        
        # Process in a separate Task to not block the GenServer
        # The task will trigger the next poll when done
        Task.start(fn -> 
          process_job(job)
          # Schedule next poll after job completes using the server's PID
          send(server_pid, :poll)
        end)
        
      {:error, :empty} ->
        Logger.debug("No jobs to process: queue is empty")
        # No job found, schedule next poll
        Process.send_after(self(), :poll, state.poll_interval)
    end
    
    {:noreply, state}
  end

  @impl true
  def handle_cast(:process_next, state) do
    # Force an immediate poll
    send(self(), :poll)
    {:noreply, state}
  end

  # Private Helper Functions
  # -----------------------

  # Process a job
  defp process_job(job) do
    # Log start time for performance tracking
    start_time = System.monotonic_time(:millisecond)
    Logger.info("Starting analysis for job #{job.id}, URL: #{job.url}")
    
    try do
      # Simulate the actual analysis
      # (In a real implementation, this would call a function to perform the analysis)
      results = analyze_website(job.url)
      
      # Record successful completion with results
      JobService.complete_job(job.id, results)
      
      # Log completion
      elapsed = System.monotonic_time(:millisecond) - start_time
      Logger.info("Successfully completed job #{job.id} in #{elapsed}ms")
      
    rescue
      e ->
        # Get stacktrace for better error reporting
        stacktrace = __STACKTRACE__ |> Exception.format_stacktrace()
        
        # Record job failure with error details
        error_data = %{
          error: Exception.message(e),
          stacktrace: stacktrace
        }
        JobService.fail_job(job.id, error_data)
        
        # Log failure
        elapsed = System.monotonic_time(:millisecond) - start_time
        Logger.error("Failed job #{job.id} after #{elapsed}ms: #{Exception.message(e)}\n#{stacktrace}")
    end
  end

  # Placeholder for actual analysis logic
  # In a real implementation, this would be replaced with actual code
  defp analyze_website(url) do
    # Simulate work by sleeping
    :timer.sleep(2000)
    
    # Return mock results
    %{
      url: url,
      timestamp: DateTime.utc_now(),
      elements: %{
        "div" => :rand.uniform(100),
        "span" => :rand.uniform(50),
        "p" => :rand.uniform(30),
        "a" => :rand.uniform(40),
        "img" => :rand.uniform(20),
        "header" => :rand.uniform(5),
        "footer" => :rand.uniform(2),
        "main" => :rand.uniform(1)
      },
      meta: %{
        title: "Example Page",
        has_viewport: true,
        responsive: true,
        load_time_ms: :rand.uniform(1000)
      }
    }
  end
end