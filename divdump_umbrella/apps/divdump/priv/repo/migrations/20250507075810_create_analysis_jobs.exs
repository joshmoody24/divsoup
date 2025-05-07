defmodule Divdump.Repo.Migrations.CreateAnalysisJobs do
  use Ecto.Migration

  def change do
    create table(:analysis_jobs) do
      add :url, :string, null: false

      timestamps()
    end

    create index(:analysis_jobs, [:url])
  end
end
