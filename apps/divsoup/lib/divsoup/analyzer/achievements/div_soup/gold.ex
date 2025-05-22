defmodule Divsoup.Achievement.DivSoupGold do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    ratio = Divsoup.Util.DivSoup.get_div_ratio(html_tree)

    if ratio > 0.75 do
      []
    else
      ["Only #{ratio * 100}% of the HTML elements in the page are divs"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :gold,
      title: "Div Stew",
      group: "div_soup",
      description: "More than 75% of the HTML elements in the page are divs"
    }
  end
end
