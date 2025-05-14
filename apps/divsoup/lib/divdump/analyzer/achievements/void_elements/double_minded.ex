defmodule Divsoup.Achievement.VoidElements.DoubleMinded do
  alias Divsoup.Achievement
  alias Divsoup.Util.Html

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_html_tree, raw_html) do
    # Analyze void elements in the HTML
    results = Html.analyze_void_elements(raw_html)

    cond do
      # Must have at least 2 void elements to potentially have both styles
      Map.get(results, :total, 0) < 2 ->
        ["Not enough void elements to determine mixed usage"]

      # Must have at least one with and one without slash for "Double-minded"
      Map.get(results, :with_slash, 0) > 0 && Map.get(results, :without_slash, 0) > 0 ->
        []

      # All are consistent (either all with slash or all without)
      true ->
        ["Void elements are used consistently (either all with or all without trailing slash)"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: :gold,
      title: "Double-minded",
      group: "void_elements",
      description: "Some void elements include a trailing slash and some do not"
    }
  end
end

