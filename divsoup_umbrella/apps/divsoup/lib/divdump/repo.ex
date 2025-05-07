defmodule Divsoup.Repo do
  use Ecto.Repo,
    otp_app: :divsoup,
    adapter: Ecto.Adapters.SQLite3
end
