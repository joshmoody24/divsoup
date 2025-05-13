defmodule Divsoup.Achievement.CrossPlatform do
  @moduledoc """
  Detects pages that are truly cross‐platform by ensuring
  no vendor‐prefixed CSS properties (`-webkit-`, `-moz-`, `-o-`, `-ms-`) appear.
  """

  alias Divsoup.Achievement
  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _raw_html_string) do
    inline_css =
      html_tree
      |> Floki.find("style")
      |> Enum.map(&Floki.text/1)

    attr_css =
      html_tree
      |> Floki.find("[style]")
      |> Enum.map(fn
        {_tag, attrs_list, _children} ->
          attrs = Map.new(attrs_list)
          Map.get(attrs, "style", "")
      end)

    css_content = Enum.join(inline_css ++ attr_css, " ")

    # note: regex first, string second
    prefixes =
      Regex.scan(~r/-webkit-|-moz-|-o-|-ms-/, css_content)
      |> List.flatten()
      |> MapSet.new()
      |> MapSet.to_list()

    case prefixes do
      [] ->
        []

      detected ->
        ["The page contains browser-specific CSS: " <> Enum.join(detected, ", ")]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Cross Platform",
      group: "cross_platform",
      description: "The page contains no browser-specific CSS, e.g., -webkit-, -moz-, -o-, -ms-"
    }
  end
end
