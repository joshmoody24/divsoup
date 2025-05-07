defmodule Divsoup.Analyzer.JobQueue do
  @moduledoc """
  A simple in-memory queue for analysis jobs.
  This GenServer maintains a queue of jobs to be processed.
  """
  use GenServer
  require Logger

  # Client API
  # ----------

  @doc """
  Starts the job queue.
  """
  def start_link(opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @doc """
  Enqueues a job for processing.
  """
  def enqueue(server \\ __MODULE__, job) do
    GenServer.cast(server, {:enqueue, job})
  end

  @doc """
  Attempts to dequeue a job from the queue.
  Returns {:ok, job} if a job is available, or {:error, :empty} if the queue is empty.
  """
  def dequeue(server \\ __MODULE__) do
    GenServer.call(server, :dequeue)
  end

  @doc """
  Returns the current queue length.
  """
  def queue_length(server \\ __MODULE__) do
    GenServer.call(server, :queue_length)
  end

  # Server Callbacks
  # ---------------

  @impl true
  def init(_opts) do
    # Initialize with an empty queue
    {:ok, %{queue: :queue.new()}}
  end

  @impl true
  def handle_cast({:enqueue, job}, %{queue: queue} = state) do
    Logger.info("Enqueuing job #{job.id} for processing")
    {:noreply, %{state | queue: :queue.in(job, queue)}}
  end

  @impl true
  def handle_call(:dequeue, _from, %{queue: queue} = state) do
    case :queue.out(queue) do
      {{:value, job}, new_queue} ->
        Logger.info("Dequeued job #{job.id}")
        {:reply, {:ok, job}, %{state | queue: new_queue}}

      {:empty, _queue} ->
        Logger.debug("Attempted to dequeue from empty queue")
        {:reply, {:error, :empty}, state}
    end
  end

  @impl true
  def handle_call(:queue_length, _from, %{queue: queue} = state) do
    {:reply, :queue.len(queue), state}
  end
end