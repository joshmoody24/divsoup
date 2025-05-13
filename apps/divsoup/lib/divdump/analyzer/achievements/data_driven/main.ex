defmodule Divsoup.Achievement.DataDriven do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _raw_html) do
    # Find all elements with data-* attributes
    data_elements = find_elements_with_data_attributes(html_tree)
    data_element_count = length(data_elements)
    
    if data_element_count > 8 do
      []
    else
      ["Only #{data_element_count} elements with data-* attributes found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Data Driven",
      group: "data_driven",
      description: "More than 8 elements on the page have data-* attributes"
    }
  end
  
  # Find all elements with data-* attributes
  defp find_elements_with_data_attributes(html_tree) do
    # Flattened list of all elements in the tree
    all_elements = Floki.find(html_tree, "*")
    
    # Filter elements that have at least one data-* attribute
    Enum.filter(all_elements, fn {_tag, attrs, _children} ->
      Enum.any?(attrs, fn {attr_name, _} ->
        String.starts_with?(attr_name, "data-")
      end)
    end)
  end
end