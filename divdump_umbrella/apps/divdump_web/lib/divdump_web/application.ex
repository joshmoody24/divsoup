defmodule DivdumpWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DivdumpWeb.Telemetry,
      # Start a worker by calling: DivdumpWeb.Worker.start_link(arg)
      # {DivdumpWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      DivdumpWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DivdumpWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DivdumpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
