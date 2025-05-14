defmodule Divsoup.Achievement.OkBoomer do
  alias Divsoup.Achievement
  alias Divsoup.Util.Html

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Get list of deprecated elements
    deprecated_elements = Html.deprecated_elements()
    
    # Find which deprecated elements are used in the page
    deprecated_elements_used = 
      deprecated_elements
      |> Enum.filter(fn tag -> 
        Floki.find(html_tree, tag) != []
      end)
    
    if deprecated_elements_used != [] do
      []
    else
      ["The page doesn't use any deprecated HTML elements"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "OK Boomer",
      group: "ok_boomer",
      description: "The page uses a deprecated HTML element"
    }
  end
end