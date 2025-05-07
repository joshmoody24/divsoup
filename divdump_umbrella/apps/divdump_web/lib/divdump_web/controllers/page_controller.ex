defmodule DivdumpWeb.PageController do
  use DivdumpWeb, :controller
  alias Divdump.Analyzer.{JobService}

  def home(conn, _params) do
    conn
    |> render(:home)
  end

  def about(conn, _params) do
    conn
    |> render(:about)
  end

  def request_analysis(conn, %{"url" => url}) do
    # Create a job to analyze the URL
    case JobService.create_job(url) do
      {:ok, job} ->
        conn
        |> put_flash(:info, "Analysis job created and scheduled for #{url}")
        |> redirect(to: ~p"/job/#{job.id}")

      {:error, reason} ->
        conn
        |> put_flash(:error, "Failed to create analysis job: #{inspect(reason)}")
        |> redirect(to: ~p"/")
    end
  end

  # View a single job by ID
  def view_job(conn, %{"id" => id}) do
    job_id = String.to_integer(id)

    case JobService.get_job(job_id) do
      {:ok, job} ->
        conn
        |> render(:analysis_results, jobs: [job])

      {:error, reason} ->
        conn
        |> put_flash(:error, "Job not found: #{reason}")
        |> redirect(to: ~p"/")
    end
  end

  # List all jobs for a URL
  def list_jobs_by_url(conn, %{"url" => url}) do
    # Get all jobs with this URL
    # For this to work properly, we should add a new function to the JobService
    # But for now, let's simulate with existing functions

    # A proper implementation would query jobs by their URL
    # For simplicity, we'll just fetch recent jobs and filter them
    jobs =
      case JobService.get_jobs_by_status(:completed, 20) do
        {:ok, jobs} ->
          # Filter jobs by URL
          Enum.filter(jobs, fn job ->
            job.url == url
          end)

        {:error, _} ->
          []
      end

    if Enum.empty?(jobs) do
      conn
      |> put_flash(:info, "No completed analysis found for #{url}. Try running a new analysis.")
      |> redirect(to: ~p"/")
    else
      conn
      |> render(:analysis_results, jobs: jobs)
    end
  end
end
