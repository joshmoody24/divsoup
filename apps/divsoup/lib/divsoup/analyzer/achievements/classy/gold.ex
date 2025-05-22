defmodule Divsoup.Achievement.ClassyGold do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, raw_html_string) do
    ratio = Divsoup.Util.Classy.get_class_ratio(html_tree, raw_html_string)

    if ratio > 0.333 do
      []
    else
      ["Only #{ratio * 100}% of the HTML elements in the page have classes"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :gold,
      title: "Aristocratic",
      group: "classy",
      description: "HTML <code>class</code> attributes make up more than <strong>one third</strong> of the page's size"
    }
  end
end
