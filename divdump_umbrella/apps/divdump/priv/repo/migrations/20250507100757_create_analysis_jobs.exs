defmodule Divdump.Repo.Migrations.CreateAnalysisJobs do
  use Ecto.Migration

  def change do
    create table(:analysis_jobs) do
      add :url, :string, null: false
      add :started_at, :utc_datetime
      add :finished_at, :utc_datetime
      add :data, :map
      add :errors, :map

      timestamps()
    end

    create index(:analysis_jobs, [:url])
  end
end
