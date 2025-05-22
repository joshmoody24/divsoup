defmodule Divsoup.Achievement.DivSoupBronze do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    ratio = Divsoup.Util.DivSoup.get_div_ratio(html_tree)

    if ratio > 0.25 do
      []
    else
      ["Only #{ratio * 100}% of the HTML elements in the page are divs"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :bronze,
      title: "Div Broth",
      group: "div_soup",
      description: "More than 25% of the HTML elements in the page are divs"
    }
  end
end
