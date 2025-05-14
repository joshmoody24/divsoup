defmodule Divsoup.Achievement.HyperlinkCollectorPlatinum do
  alias Divsoup.Achievement
  alias Divsoup.Util.Hyperlink

  @behaviour Divsoup.AchievementRule
  
  # Minimum number of unique external domains required
  @min_domains 50

  @impl true
  def evaluate(html_tree, _) do
    # Count unique external domains
    domain_count = Hyperlink.count_unique_external_domains(html_tree)
    
    if domain_count >= @min_domains do
      []
    else
      ["The page only links to #{domain_count} different external domains, needs at least #{@min_domains}"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :platinum,
      title: "Hyperlink Connoisseur",
      group: "hyperlink_collector",
      description: "The page links to at least #{@min_domains} different external domains"
    }
  end
end