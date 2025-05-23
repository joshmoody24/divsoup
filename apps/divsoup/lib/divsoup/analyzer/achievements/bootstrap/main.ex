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
        "Page does not contain a reference to Bootstrap"
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
      description: "Page contains links to <a href=\"https://getbootstrap.com/\" target=\"_blank\">Bootstrap</a> CSS or JS"
    }
  end
end
