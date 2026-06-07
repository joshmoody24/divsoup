defmodule DivsoupWeb.PageController do
  use DivsoupWeb, :controller
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

end
