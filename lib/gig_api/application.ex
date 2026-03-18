defmodule GigApi.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GigApiWeb.Telemetry,
      GigApi.Repo,
      {Phoenix.PubSub, name: GigApi.PubSub},
      GigApi.Events.SoldOutChecker,
      GigApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: GigApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    GigApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
