defmodule Divsoup.Achievement.DivSoupSilver do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    ratio = Divsoup.Util.DivSoup.get_div_ratio(html_tree)

    if ratio > 0.50 do
      []
    else
      ["Only #{ratio * 100}% of the HTML elements in the page are divs"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :silver,
      title: "Div Soup",
      group: "div_soup",
      description: "More than <strong>50%</strong> of the HTML elements in the page are <code>&lt;div&gt;</code> elements"
    }
  end
end
