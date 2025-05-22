defmodule Divsoup.Achievement.PreemptiveStrike do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Find all link elements
    link_elements = Floki.find(html_tree, "link")
    
    # Check for preload, dns-prefetch, or preconnect rel attributes
    preemptive_links = Enum.filter(link_elements, fn link ->
      {_, attrs, _} = link
      attrs_map = Enum.into(attrs, %{})
      rel = Map.get(attrs_map, "rel", "")
      
      String.contains?(rel, "preload") || 
      String.contains?(rel, "dns-prefetch") || 
      String.contains?(rel, "preconnect")
    end)
    
    if Enum.empty?(preemptive_links) do
      ["Page does not include any preload, dns-prefetch, or preconnect link elements"]
    else
      # Achievement earned
      []
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Preemptive Strike",
      group: "preemptive_strike",
      description: "Page includes a <code>&lt;link rel=\"preload\"&gt;</code>, <code>&lt;link rel=\"dns-prefetch\"&gt;</code>, or <code>&lt;link rel=\"preconnect\"&gt;</code>"
    }
  end
end