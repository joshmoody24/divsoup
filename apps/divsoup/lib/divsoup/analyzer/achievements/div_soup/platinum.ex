defmodule Divsoup.Achievement.DivSoupPlatinum do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    ratio = Divsoup.Util.DivSoup.get_div_ratio(html_tree)

    if ratio > 0.90 do
      []
    else
      ["Only #{ratio * 100}% of the HTML elements in the page are divs"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :platinum,
      title: "Div Casserole",
      group: "div_soup",
      description: "More than <strong>90%</strong> of the HTML elements in the page are <code>&lt;div&gt;</code>s"
    }
  end
end
