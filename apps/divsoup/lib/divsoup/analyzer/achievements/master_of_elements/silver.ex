defmodule Divsoup.Achievement.MasterOfElements.Silver do
  alias Divsoup.Achievement
  alias Divsoup.Util.Html

  @behaviour Divsoup.AchievementRule
  
  # Required number of unique elements for silver achievement
  @required_elements 60

  @impl true
  def evaluate(html_tree, _) do
    # Count valid unique elements
    valid_element_count = Html.count_valid_elements_used(html_tree)
    
    if valid_element_count >= @required_elements do
      []
    else
      ["Page only uses #{valid_element_count} different valid HTML elements, needs at least #{@required_elements}"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: :silver,
      title: "Elementary, My Dear Watson",
      group: "master_of_elements",
      description: "Page uses at least <strong>#{@required_elements}</strong> different HTML elements"
    }
  end
end
