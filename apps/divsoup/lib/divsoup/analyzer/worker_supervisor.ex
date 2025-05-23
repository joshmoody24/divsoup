defmodule Divsoup.Analyzer.WorkerSupervisor do
  @moduledoc """
  Supervisor for website analysis worker processes.
  Dynamically manages a pool of workers based on configuration.
  """
  use Supervisor
  require Logger

  # Client API

  @doc """
  Starts the worker supervisor with the specified options.
  """
  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # Server Callbacks

  @impl true
  def init(_opts) do
    # Get the worker count from config, defaulting to 1
    worker_count = Application.get_env(:divsoup, :worker_count, 1)

    Logger.info("Starting #{worker_count} analysis worker(s)")

    # Define child specifications for workers
    children = 
      for i <- 1..worker_count do
        worker_name = :"Divsoup.Analyzer.Worker#{i}"
        
        Supervisor.child_spec(
          {Divsoup.Analyzer.Worker, [name: worker_name, worker_id: "worker_#{i}"]},
          id: worker_name
        )
      end

    # Start with a simple_one_for_one strategy so workers are restarted independently
    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Returns the number of active workers.
  """
  def worker_count do
    Supervisor.count_children(__MODULE__).active
  end
end