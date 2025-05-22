defmodule Divsoup.Achievement.Progressive do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Check for progress elements
    progress_elements = Floki.find(html_tree, "progress")
    has_progress = progress_elements != []
    
    # Check for meter elements
    meter_elements = Floki.find(html_tree, "meter")
    has_meter = meter_elements != []
    
    cond do
      has_progress && has_meter ->
        # Achievement earned - both elements present
        []
        
      !has_progress && !has_meter ->
        ["Page contains neither a <progress> nor a <meter> element"]
        
      !has_progress ->
        ["Page contains a <meter> element but no <progress> element"]
        
      !has_meter ->
        ["Page contains a <progress> element but no <meter> element"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Progressive",
      group: "progressive",
      description: "Page contains both a <progress> and <meter> element"
    }
  end
end