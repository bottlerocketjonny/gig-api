import Config

config :gig_api, GigApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: GigApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: GigApi.PubSub,
  live_view: [signing_salt: "gig_api_salt"]

config :gig_api,
  ecto_repos: [GigApi.Repo],
  generators: [timestamp_type: :utc_datetime]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config
import_config "#{config_env()}.exs"
