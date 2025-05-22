import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :divsoup, Divsoup.Repo,
  database: Path.expand("../divsoup_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.SQLite3

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :divsoup_web, DivsoupWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "yIIbm27PBQG8XIQqKy9DioyPOWUZadt5lKWBYXiHN8SnzHh5r+W5cQ71aRA28Vez",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# In test we don't send emails
config :divsoup, Divsoup.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
