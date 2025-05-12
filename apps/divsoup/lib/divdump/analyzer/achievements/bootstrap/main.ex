defmodule Divsoup.Achievement.Bootstrap do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    bootstrap_links = Floki.find(html_tree, "link[href*=\"bootstrap\"]")
    bootstrap_scripts = Floki.find(html_tree, "script[src*=\"bootstrap\"]")
    bootstrap_references = bootstrap_links ++ bootstrap_scripts

    if Enum.empty?(bootstrap_references) do
      [
        "The page does not contain a reference to Bootstrap"
      ]
    else
      []
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Not like the other girls",
      group: "bootstrap",
      description: "The page links to Bootstrap CSS or JS"
    }
  end
end
