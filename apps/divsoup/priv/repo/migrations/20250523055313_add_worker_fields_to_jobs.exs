defmodule Divsoup.Repo.Migrations.AddWorkerFieldsToJobs do
  use Ecto.Migration

  def change do
    alter table(:analysis_jobs) do
      # Worker that claimed this job
      add :claimed_by, :string
      # When the job was claimed
      add :claimed_at, :utc_datetime
      # Number of retries if the job failed
      add :retry_count, :integer, default: 0, null: false
      # Maximum number of retries allowed
      add :max_retries, :integer, default: 3, null: false
    end

    # Add index for finding jobs claimed by a specific worker
    create index(:analysis_jobs, [:claimed_by])
    # Add index for finding jobs that haven't been claimed yet
    create index(:analysis_jobs, [:claimed_at])
  end
end
