defmodule Divsoup.Repo.Migrations.ChangeJobIdToUuid do
  use Ecto.Migration

  def up do
    # Drop existing table and recreate with UUID primary key
    drop_if_exists table(:analysis_jobs)

    # Recreate the table with UUID primary key
    create table(:analysis_jobs, primary_key: false) do
      add :id, :binary_id, primary_key: true
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

  def down do
    # Revert to original table with integer primary key
    drop_if_exists table(:analysis_jobs)

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
