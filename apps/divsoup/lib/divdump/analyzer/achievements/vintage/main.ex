defmodule Divsoup.Achievement.Vintage do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    nested_tables = Floki.find(html_tree, "table table")

    if length(nested_tables) > 0 do
      []
    else
      ["The page does not use nested table layouts"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Vintage",
      group: "vintage",
      description: "The page uses nested table layouts"
    }
  end
end
