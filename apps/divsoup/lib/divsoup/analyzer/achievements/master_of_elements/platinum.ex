defmodule Divsoup.Achievement.MasterOfElements.Platinum do
  alias Divsoup.Achievement
  alias Divsoup.Util.Html

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Get all possible HTML elements
    all_possible_elements = Html.all_elements() |> MapSet.new()
    
    # Find all valid elements actually used in the HTML
    used_elements = Html.get_valid_elements_used(html_tree)
    
    # Calculate missing elements
    missing_elements = MapSet.difference(all_possible_elements, used_elements)
    
    if MapSet.size(missing_elements) == 0 do
      # All elements are used!
      []
    else
      missing_count = MapSet.size(missing_elements)
      total_count = MapSet.size(all_possible_elements)
      ["Page is missing #{missing_count} out of #{total_count} possible HTML elements"]
    end
  end

  @impl true
  def achievement do
    total_elements = Html.count_all_elements()
    
    %Achievement{
      hierarchy: :platinum,
      title: "Master of All #{total_elements} Elements",
      group: "master_of_elements",
      description: "Page uses <strong>every HTML element</strong>, even the deprecated ones"
    }
  end
end
