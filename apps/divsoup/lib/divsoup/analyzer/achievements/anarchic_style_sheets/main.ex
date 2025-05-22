defmodule Divsoup.Achievement.AnarchicStyleSheets do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule
  
  # Required number of style elements in body
  @required_styles 3

  @impl true
  def evaluate(html_tree, _) do
    # Find all style elements within body
    body_styles = Floki.find(html_tree, "body style")
    style_count = length(body_styles)
    
    if style_count >= @required_styles do
      # Achievement earned
      []
    else
      ["Page only has #{style_count} style elements in the body, needs at least #{@required_styles}"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Anarchic Style Sheets",
      group: "anarchic_style_sheets",
      description: "Page has #{@required_styles} or more <style> elements scattered within the <body>"
    }
  end
end