defmodule Divdump.Analyzer.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "analysis_jobs" do
    field :url, :string
    has_many :job_events, Divdump.Analyzer.JobEvent

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
