defmodule Divsoup.Achievement.ClassySilver do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, raw_html_string) do
    ratio = Divsoup.Util.Classy.get_class_ratio(html_tree, raw_html_string)

    if ratio > 0.25 do
      []
    else
      ["Only #{ratio * 100}% of the HTML elements in the page have classes"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :silver,
      title: "Sophisticated",
      group: "classy",
      description: "HTML class attributes make up more than 25% of the page's size"
    }
  end
end
