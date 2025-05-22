defmodule Divsoup.Achievement.ShallowOcean do
  @moduledoc """
  Checks that the average nesting depth of all elements under <body> does not exceed a defined maximum.
  """

  alias Divsoup.Achievement
  @behaviour Divsoup.AchievementRule

  # Maximum average depth for the achievement
  @max_avg_depth 3

  @impl true
  def evaluate(html_tree, _context) do
    case Floki.find(html_tree, "body") do
      [] ->
        ["Page has no <body> element"]

      [body | _] ->
        depths = calculate_depths(body)

        cond do
          depths == [] ->
            ["<body> contains no elements"]

          average_depth(depths) <= @max_avg_depth ->
            []

          true ->
            avg = Float.round(average_depth(depths), 2)
            ["Average element depth is #{avg}, which exceeds the maximum of #{@max_avg_depth}"]
        end
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Shallow Ocean",
      group: "shallow_ocean",
      description: "Average depth of all elements inside <body> is #{@max_avg_depth} or less"
    }
  end

  # Recursively traverse from the <body> node to calculate each element's depth.
  defp calculate_depths({_, _attrs, children}), do: calculate_depths(children, 1)

  defp calculate_depths(nodes, current_depth) when is_list(nodes) do
    Enum.flat_map(nodes, fn
      {tag, _attrs, grand_children} when is_binary(tag) ->
        [current_depth | calculate_depths(grand_children, current_depth + 1)]

      _other ->
        []
    end)
  end

  defp calculate_depths(_, _), do: []

  # Compute the average, safe for empty lists.
  defp average_depth([]), do: 0

  defp average_depth(depths) do
    Enum.sum(depths) / length(depths)
  end
end
