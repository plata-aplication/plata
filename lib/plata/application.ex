defmodule Plata.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlataWeb.Telemetry,
      Plata.Repo,
      {DNSCluster, query: Application.get_env(:plata, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Plata.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Plata.Finch},
      # Start a worker by calling: Plata.Worker.start_link(arg)
      # {Plata.Worker, arg},
      # Start to serve requests, typically the last entry
      PlataWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Plata.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlataWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
