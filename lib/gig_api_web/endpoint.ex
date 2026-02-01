defmodule GigApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :gig_api

  @session_options [
    store: :cookie,
    key: "_gig_api_key",
    signing_salt: "gig_api_salt",
    same_site: "Lax"
  ]

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :gig_api
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug GigApiWeb.Router
end
