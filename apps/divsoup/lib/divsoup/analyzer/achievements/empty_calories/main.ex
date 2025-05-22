defmodule Divsoup.Achievement.EmptyCalories do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Find empty div and span elements
    empty_elements = find_empty_elements(html_tree)
    empty_count = length(empty_elements)

    if empty_count >= 10 do
      []
    else
      ["Only #{empty_count} empty div or span elements found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Empty Calories",
      group: "empty_calories",
      description: "Page contains 10 or more empty <div> or <span> elements"
    }
  end

  defp find_empty_elements(html_tree) do
    # Get all div and span elements
    divs_and_spans = Floki.find(html_tree, "div, span")

    # Filter to only empty elements (no text content, no child elements)
    Enum.filter(divs_and_spans, fn element ->
      # Get element content
      {_, _attrs, children} = element

      # Check if it has no text and no child elements
      # Empty elements either have no children or only have whitespace text nodes
      is_empty =
        children == [] or
          Enum.all?(children, fn child ->
            case child do
              text when is_binary(text) -> String.trim(text) == ""
              _ -> false
            end
          end)

      # Check if it has no non-whitespace content
      is_empty
    end)
  end
end

