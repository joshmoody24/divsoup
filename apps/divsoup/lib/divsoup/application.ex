defmodule Divsoup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Initialize the job metrics cache
    Divsoup.Analyzer.JobService.init_cache()
    
    children = [
      Divsoup.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:divsoup, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:divsoup, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Divsoup.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Divsoup.Finch},
      # Start the job queue
      {Divsoup.Analyzer.JobQueue, []},
      # Start the worker supervisor (which will start multiple workers)
      {Divsoup.Analyzer.WorkerSupervisor, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Divsoup.Supervisor)
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
