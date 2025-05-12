defmodule Divsoup.Achievement.Quirky do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_, raw_html_string) do
    quirks_mode = not String.match?(raw_html_string, ~r/<!DOCTYPE html>/i)

    if quirks_mode do
      []
    else
      ["The page does not render in quirks mode"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Quirky",
      group: "quirky",
      description: "The page renders in quirks mode"
    }
  end
end
