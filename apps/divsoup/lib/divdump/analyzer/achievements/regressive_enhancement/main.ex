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
      ["The page does not include a <noscript> element"]
    else
      # Check that at least one noscript element has minimal content
      has_barely_anything = 
        noscript_elements
        |> Enum.any?(fn element ->
          text = Floki.text(element)
          clean_text = String.replace(text, ~r/\s/, "") # Remove all whitespace
          String.length(clean_text) < @max_chars
        end)
      
      if has_barely_anything do
        []
      else
        ["The page includes <noscript> elements, but they all have substantial content"]
      end
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Regressive Enhancement",
      group: "regressive_enhancement",
      description: "The page includes a <noscript> element with barely anything in it (less than 100 characters, excluding whitespace)"
    }
  end
end