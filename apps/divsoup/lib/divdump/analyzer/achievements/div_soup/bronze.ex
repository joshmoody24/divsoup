defmodule Divsoup.Achievement.DivSoupBronze do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree) do
    ratio = Divsoup.Util.DivSoup.get_div_ratio(html_tree)
    ratio > 0.25
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :bronze,
      title: "Div Soup",
      description: "More than 25% of the HTML elements in the page are divs"
    }
  end
end
