defmodule Divsoup.Achievement.SelfLove do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Find anchor elements with href="#"
    self_links = Floki.find(html_tree, "a[href=\"#\"]")
    
    if length(self_links) > 0 do
      []
    else
      ["No anchor with href=\"#\" found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Self Love",
      group: "self_love",
      description: "Page contains an <a href=\"#\">"
    }
  end
end