defmodule Divsoup.Achievement.OopsAllFrameworks do
  alias Divsoup.Achievement
  alias Divsoup.Util.WebFramework

  @behaviour Divsoup.AchievementRule
  @required_frameworks ["React", "Vue", "Angular"]

  @impl true
  def evaluate(html_tree, _) do
    # Get detected frameworks using the utility
    detected_frameworks = WebFramework.detected_web_frameworks(html_tree)
    
    # Check if all required frameworks are detected
    missing_frameworks = @required_frameworks -- detected_frameworks
    
    if Enum.empty?(missing_frameworks) do
      []
    else
      ["Missing frameworks: #{Enum.join(missing_frameworks, ", ")}"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Oops, All Frameworks",
      group: "oops_all_frameworks",
      description: "Page uses React, Vue, and Angular simultaneously"
    }
  end
end