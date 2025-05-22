defmodule Divsoup.Achievement.CrossPlatform do
  @moduledoc """
  Detects pages that use browser-specific CSS properties to
  ensure a fragmented ecosystem (`-webkit-`, `-moz-`, `-o-`, `-ms-`).
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
        ["No browser-specific CSS found"]

      _detected ->
        [] # Achievement earned when browser-specific CSS is present
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Fragmented Ecosystem",
      group: "cross_platform",
      description: "Page contains browser-specific CSS, e.g., <code>-webkit-</code>, <code>-moz-</code>, <code>-o-</code>, <code>-ms-</code>"
    }
  end
end
