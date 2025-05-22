defmodule Divsoup.Achievement.HyperlinkCollectorSilver do
  alias Divsoup.Achievement
  alias Divsoup.Util.Hyperlink

  @behaviour Divsoup.AchievementRule
  
  # Minimum number of unique external domains required
  @min_domains 10

  @impl true
  def evaluate(html_tree, _) do
    # Count unique external domains
    domain_count = Hyperlink.count_unique_external_domains(html_tree)
    
    if domain_count >= @min_domains do
      []
    else
      ["Page only links to #{domain_count} different external domains, needs at least #{@min_domains}"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :silver,
      title: "Hyperlink Custodian",
      group: "hyperlink_collector",
      description: "Page contains links to at least <strong>#{@min_domains}</strong> different external domains"
    }
  end
end
