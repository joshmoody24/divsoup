defmodule Divsoup.Achievement.FaviconFanatic do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Get the head element
    head = Floki.find(html_tree, "head")

    # Find all link elements with rel="icon" within the head
    favicon_links = Floki.find(head, "link[rel=\"icon\"]")
    favicon_count = length(favicon_links)

    if favicon_count > 3 do
      []
    else
      ["Only #{favicon_count} favicon links found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Favicon Fanatic",
      group: "favicon_fanatic",
      description: "The head has more than <strong>3</strong> <code>&lt;link rel=\"icon\"&gt;</code> elements"
    }
  end
end
