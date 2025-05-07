defmodule Divdump.Repo.Migrations.CreateJobEvents do
  use Ecto.Migration

  def change do
    create table(:job_events) do
      add :status, :string, null: false
      add :data, :map
      add :timestamp, :utc_datetime, null: false, default: fragment("CURRENT_TIMESTAMP")
      # no references constraint on job_id because sqlite doesn't support it
      add :job_id, :integer, null: false

      timestamps()
    end

    create index(:job_events, [:job_id])
    create index(:job_events, [:status])
  end
end
