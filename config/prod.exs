import Config

# Configure your database
config :divsoup, Divsoup.Repo,
  username: "postgres",
  password: System.get_env("DB_PASSWORD") || "postgres",
  hostname: System.get_env("DB_HOST") || "localhost",
  database: "divsoup_dev",
  pool_size: 10,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  adapter: Ecto.Adapters.Postgres,
  ssl: true

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :divsoup_web, DivsoupWeb.Endpoint,
  url: [host: "127.0.0.1", port: 4000],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Configures Swoosh API Client
config :swoosh, :api_client, Divsoup.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
