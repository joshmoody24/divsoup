defmodule Divsoup.Achievement.BackwardsCompatibility do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_html_tree, raw_html) do
    # Check for conditional comments for IE
    if has_ie_conditional_comment?(raw_html) do
      []
    else
      ["No IE conditional comment found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Backwards Compatibility",
      group: "backwards_compatibility",
      description: "Page contains an <code>&lt;!--[if IE]&gt;...&lt;![endif]--&gt;</code> comment"
    }
  end
  
  defp has_ie_conditional_comment?(html) do
    # Regex to detect conditional comments for IE
    ie_pattern = ~r/<!--\s*\[\s*if\s+IE\s*\].*?\<\!\[endif\]\s*-->/s
    Regex.match?(ie_pattern, html)
  end
end
