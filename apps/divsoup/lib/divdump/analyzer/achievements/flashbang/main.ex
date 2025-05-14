defmodule Divsoup.Achievement.Flashbang do
  alias Divsoup.Achievement
  alias Divsoup.Util.Color

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, raw_html) do
    # Get the background color of the page
    bg_color = Color.extract_background_color(html_tree, raw_html)
    
    # Check if the page has dark mode support
    has_dark_mode = Color.has_dark_mode_support?(html_tree, raw_html)
    
    cond do
      # If there's proper dark mode support, no achievement
      has_dark_mode ->
        ["Page properly supports dark mode"]
        
      # If there's no background color, can't determine
      is_nil(bg_color) ->
        ["Could not determine page background color"]
        
      # If background is light, award the achievement
      Color.is_light_color?(bg_color) ->
        []
        
      # Otherwise, not a light background
      true ->
        ["Page does not have a light background"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Flashbang",
      group: "flashbang",
      description: "The primary background color is light when the user prefers dark mode"
    }
  end
end