defmodule Divsoup.Achievement.VoidElements.CloseMinded do
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
        
      # All void elements must have trailing slash for "Close-minded"
      Map.get(results, :with_slash, 0) == Map.get(results, :total, 0) ->
        []
        
      # Some don't have trailing slash
      true ->
        ["Not all void elements include a trailing slash (#{Map.get(results, :with_slash, 0)} of #{Map.get(results, :total, 0)} have slashes)"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Close-minded",
      group: "void_elements",
      description: "All void elements include a trailing slash (<code>&lt;img /&gt;</code>)"
    }
  end
end
