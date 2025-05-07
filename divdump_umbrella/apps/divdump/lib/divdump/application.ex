defmodule Divdump.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Divdump.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:divdump, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:divdump, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Divdump.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Divdump.Finch},
      # Start the job queue
      {Divdump.Analyzer.JobQueue, []},
      # Start the analysis worker
      {Divdump.Analyzer.Worker, [poll_interval: 5_000]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Divdump.Supervisor)
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
