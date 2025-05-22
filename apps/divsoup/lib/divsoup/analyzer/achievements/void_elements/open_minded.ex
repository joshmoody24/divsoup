defmodule Divsoup.Achievement.VoidElements.OpenMinded do
  alias Divsoup.Achievement
  alias Divsoup.Util.Html

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_html_tree, raw_html) do
    # Analyze void elements in the HTML
    results = Html.analyze_void_elements(raw_html)

    cond do
      # Must have some void elements to qualify
      Map.get(results, :total, 0) == 0 ->
        ["No void elements found in the page"]

      # All void elements must NOT have trailing slash for "Open-minded"
      Map.get(results, :without_slash, 0) == Map.get(results, :total, 0) ->
        []

      # Some have trailing slash
      true ->
        [
          "Not all void elements omit the trailing slash (#{Map.get(results, :without_slash, 0)} of #{Map.get(results, :total, 0)} without slashes)"
        ]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: :gold,
      title: "Open-minded",
      group: "void_elements",
      description: "No void elements include a trailing slash (<code>&lt;img&gt;</code> not <code>&lt;img /&gt;</code>)"
    }
  end
end

