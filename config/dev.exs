import Config

config :gig_api, GigApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "gig_api_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For dev, disable any cache and enable debugging and code reloading
config :gig_api, GigApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "gig_api_dev_secret_key_base_that_is_at_least_64_bytes_long_for_security",
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
