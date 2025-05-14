defmodule Divsoup.Achievement.RegressiveEnhancement do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  # Maximum number of characters (excluding whitespace) for the achievement
  @max_chars 100

  @impl true
  def evaluate(html_tree, _) do
    # Find all noscript elements
    noscript_elements = Floki.find(html_tree, "noscript")

    if noscript_elements == [] do
      ["Page does not include a <noscript> element"]
    else
      # Check that at least one noscript element has minimal content
      has_barely_anything =
        noscript_elements
        |> Enum.any?(fn element ->
          text = Floki.text(element)
          # Remove all whitespace
          clean_text = String.replace(text, ~r/\s/, "")
          String.length(clean_text) < @max_chars
        end)

      if has_barely_anything do
        []
      else
        ["Page includes <noscript> elements, but they all have substantial content"]
      end
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Regressive Enhancement",
      group: "regressive_enhancement",
      description: "Page includes a <noscript> element with barely anything in it"
    }
  end
end

