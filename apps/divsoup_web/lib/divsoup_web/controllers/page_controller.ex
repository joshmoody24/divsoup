defmodule DivsoupWeb.PageController do
  use DivsoupWeb, :controller
  alias Divsoup.Analyzer.{JobService}
  alias Divsoup.AchievementList

  def home(conn, _params) do
    conn
    |> assign(:title, "Home")
    |> render(:home)
  end

  def about(conn, _params) do
    conn
    |> assign(:title, "About")
    |> render(:about)
  end
  
  def list_achievements(conn, _params) do
    # Get all achievement modules
    all_achievements = 
      AchievementList.all()
      |> Enum.map(fn module -> module.achievement() end)
      
    # Group by category
    achievements_by_group = 
      all_achievements
      |> Enum.group_by(fn a -> a.group end)
      
    # Sort achievements within each group
    sorted_groups =
      achievements_by_group
      |> Enum.map(fn {group, group_achievements} ->
        sorted_achievements = Enum.sort_by(group_achievements, fn a -> 
          {achievement_level_to_number(a.hierarchy), a.title} 
        end)
        {group, sorted_achievements}
      end)
      
    # Sort groups by number of achievements (descending)
    sorted_achievements = 
      sorted_groups
      |> Enum.sort_by(fn {_group, group_achievements} -> 
        -length(group_achievements) # Negative for descending order
      end)
    
    conn
    |> assign(:title, "Achievements")
    |> assign(:achievements, sorted_achievements)
    |> render(:achievements)
  end
  
  # Helper to convert hierarchy to sortable number
  defp achievement_level_to_number(level) do
    case level do
      :bronze -> 1
      :silver -> 2
      :gold -> 3
      :platinum -> 4
      _ -> 0
    end
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

    case JobService.get_job_with_metrics(job_id) do
      {:ok, results} ->
        conn
        |> assign(:title, "Analysis")
        |> render(:analysis_results, jobs: [results.job], achievements: results.achievements)

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
      |> assign(:title, "Analysis")
      |> render(:analysis_results, jobs: jobs)
    end
  end
end
