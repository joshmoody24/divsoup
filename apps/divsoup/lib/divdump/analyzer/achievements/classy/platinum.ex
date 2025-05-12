defmodule Divsoup.Achievement.ClassyPlatinum do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, raw_html_string) do
    ratio = Divsoup.Util.Classy.get_class_ratio(html_tree, raw_html_string)

    if ratio > 0.5 do
      []
    else
      ["Only #{ratio * 100}% of the HTML elements in the page have classes"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :platinum,
      title: "Opulent",
      group: "classy",
      description: "HTML classes make up more than 50% of the page's size"
    }
  end
end
