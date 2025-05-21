defmodule Divsoup.Repo do
  use Ecto.Repo,
    otp_app: :divsoup,
    adapter: get_adapter()

  # Select database adapter based on environment variable or environment
  # - Default to SQLite for dev/test 
  # - Default to Postgres for production
  # - Override with DB_ADAPTER=postgres or DB_ADAPTER=sqlite
  defp get_adapter do
    db_adapter = System.get_env("DB_ADAPTER")
    
    cond do
      db_adapter == "postgres" -> Ecto.Adapters.Postgres
      db_adapter == "sqlite" -> Ecto.Adapters.SQLite3
      Mix.env() == :prod -> Ecto.Adapters.Postgres
      true -> Ecto.Adapters.SQLite3
    end
  end
end
