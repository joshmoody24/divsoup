defmodule Divsoup.Achievement.SeoSleazeball do
  @moduledoc """
  Detects pages that include SEO-oriented meta tags:
    • Open Graph (`<meta property="og:*">`)
    • Twitter Card (`<meta name="twitter:*">`)
    • Standard meta description (`<meta name="description">`)

  Returns an empty list when all three are present, or
  a list of messages for any that are missing.
  """

  alias Divsoup.Achievement
  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _raw_html_string) do
    checks = [
      {"Open Graph meta tags", present?(Floki.find(html_tree, "meta[property^=\"og:\"]"))},
      {"Twitter Card meta tags", present?(Floki.find(html_tree, "meta[name^=\"twitter:\"]"))},
      {"meta description tag", present?(Floki.find(html_tree, "meta[name=\"description\"]"))}
    ]

    checks
    |> Enum.filter(fn {_desc, ok?} -> not ok? end)
    |> Enum.map(fn {desc, _} -> "Page does not use " <> desc end)
  end

  defp present?([]), do: false
  defp present?(_), do: true

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "SEO Sleazeball",
      group: "seo_sleazeball",
      description: "Page includes Open Graph, Twitter Card, and description <code>&lt;meta&gt;</code> tags"
    }
  end
end
