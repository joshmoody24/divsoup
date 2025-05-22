defmodule Divsoup.Achievement.DeepPuddle do
  @moduledoc """
  Checks that the page body contains a chain of at least @min_chain_length nested elements
  where each parent has exactly one child.
  """

  alias Divsoup.Achievement
  @behaviour Divsoup.AchievementRule

  # Minimum length of single-child chain required for the achievement
  @min_chain_length 8

  @impl true
  def evaluate(html_tree, _context) do
    case Floki.find(html_tree, "body") do
      [] ->
        ["Page has no <body> element"]

      [body | _] ->
        longest = find_longest_single_child_chain(body)

        if longest >= @min_chain_length do
          []
        else
          [
            "Longest single-child chain is #{longest}, but needs to be at least #{@min_chain_length}"
          ]
        end
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Deep Puddle",
      group: "tree_shenanigans",
      description:
      "The page body contains a descendant chain of at least <strong>#{@min_chain_length}</strong> elements \
        where each parent has only one child"
    }
  end

  # Public entry: start chain count at 1 for the <body> node
  defp find_longest_single_child_chain({_, _attrs, children}) do
    find_chain(children, 1)
  end

  # Non-element nodes contribute no chain
  defp find_longest_single_child_chain(_), do: 0

  # Traverse a list of child nodes, tracking the current chain length
  defp find_chain(nodes, count) when is_list(nodes) do
    # Keep only element tuples
    element_children =
      Enum.filter(nodes, fn
        {tag, _, _} when is_binary(tag) -> true
        _ -> false
      end)

    case element_children do
      # Exactly one child: continue the chain
      [{_, _, grandchildren}] ->
        find_chain(grandchildren, count + 1)

      # No element children: chain ends here
      [] ->
        count

      # Multiple children: chain breaks, compute longest chain in each subtree
      list ->
        list
        |> Enum.map(&find_longest_single_child_chain/1)
        |> Enum.max(fn -> 0 end)
    end
  end
end

