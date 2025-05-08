defmodule Divsoup.Repo.Migrations.CreateAnalysisJobs do
  use Ecto.Migration

  def change do
    create table(:analysis_jobs) do
      add :url, :string, null: false
      add :started_at, :utc_datetime
      add :finished_at, :utc_datetime
      add :html_url, :string
      add :screenshot_url, :string
      add :pdf_url, :string
      add :errors, :map

      timestamps()
    end

    create index(:analysis_jobs, [:url])
  end
end
