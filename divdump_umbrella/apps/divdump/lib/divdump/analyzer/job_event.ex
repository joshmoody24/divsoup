defmodule Divdump.Analyzer.JobEvent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "job_events" do
    field :data, :map
    field :status, Ecto.Enum, values: [:pending, :in_progress, :completed, :failed]
    field :timestamp, :utc_datetime
    belongs_to :job, Divdump.Analyzer.Job

    timestamps()
  end

  @doc false
  def changeset(job_event, attrs) do
    job_event
    |> cast(attrs, [:status, :data, :timestamp, :job_id])
    |> validate_required([:status, :timestamp, :job_id])
  end
end
