defmodule Divsoup.Achievement.Hydra do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Find all h1 elements
    h1_elements = Floki.find(html_tree, "h1")
    h1_count = length(h1_elements)
    
    if h1_count > 1 do
      []
    else
      ["Only #{h1_count} h1 element found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Hydra",
      group: "hydra",
      description: "Page contains multiple <h1> elements"
    }
  end
end