defmodule Divsoup.Repo do
  # Determine adapter based on environment variable or default to SQLite
  @adapter (case System.get_env("DB_ADAPTER", "sqlite") do
    "postgres" -> Ecto.Adapters.Postgres
    _ -> Ecto.Adapters.SQLite3
  end)

  use Ecto.Repo,
    otp_app: :divsoup,
    adapter: @adapter
end
