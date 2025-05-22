defmodule Divsoup.Achievement.SmallData do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Check for JSON-LD or Microdata structured data
    has_json_ld = has_json_ld?(html_tree)
    has_microdata = has_microdata?(html_tree)
    
    if has_json_ld or has_microdata do
      []
    else
      ["No JSON-LD or Microdata found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Small Data",
      group: "small_data",
      description: "Page uses <code>JSON-LD</code> or <code>Microdata</code>"
    }
  end
  
  defp has_json_ld?(html_tree) do
    # Check for script elements with type="application/ld+json"
    json_ld_scripts = Floki.find(html_tree, "script[type=\"application/ld+json\"]")
    length(json_ld_scripts) > 0
  end
  
  defp has_microdata?(html_tree) do
    # Check for elements with itemscope, itemtype, or itemprop attributes
    microdata_elements = Floki.find(html_tree, "[itemscope], [itemtype], [itemprop]")
    length(microdata_elements) > 0
  end
end