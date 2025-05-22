defmodule Divsoup.Achievement.TypeHints do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Find datalist elements
    datalist_elements = Floki.find(html_tree, "datalist")
    
    if length(datalist_elements) > 0 do
      []
    else
      ["No datalist element found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Type Hints",
      group: "semistatic_types",
      description: "Page uses a <code>&lt;datalist&gt;</code> element"
    }
  end
end
