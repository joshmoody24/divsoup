defmodule Divdump.Repo do
  use Ecto.Repo,
    otp_app: :divdump,
    adapter: Ecto.Adapters.SQLite3
end
