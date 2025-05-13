defmodule Divsoup.Achievement.DynamicContent do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Find output elements
    output_elements = Floki.find(html_tree, "output")
    
    if length(output_elements) > 0 do
      []
    else
      ["No output element found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Dynamic Content",
      group: "dynamic_content",
      description: "Page uses an <output> element"
    }
  end
end