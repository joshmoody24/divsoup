defmodule Divsoup.Achievement.TowerOfBabel do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Find all elements with a lang attribute
    elements_with_lang = Floki.find(html_tree, "*[lang]") 
    
    # Extract the lang attribute values
    lang_values = 
      elements_with_lang
      |> Enum.map(fn element -> 
        Floki.attribute(element, "lang") |> List.first()
      end)
      |> Enum.uniq()

    # Check if there are at least 2 different lang values
    if length(lang_values) >= 2 do
      []
    else
      ["Page does not contain at least 2 different lang attributes"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Tower of Babel",
      group: "tower_of_babel",
      description: "Page contains at least 2 lang attributes with different values"
    }
  end
end