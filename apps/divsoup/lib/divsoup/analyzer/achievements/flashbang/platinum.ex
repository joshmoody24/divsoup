defmodule Divsoup.Achievement.ChaoticEvil do
  alias Divsoup.Achievement
  alias Divsoup.Util.Color

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, raw_html) do
    # Check for inverted color scheme behavior
    light_in_dark = Color.has_light_in_dark_mode?(html_tree, raw_html)
    dark_in_light = Color.has_dark_in_light_mode?(html_tree, raw_html)
    
    # Check for any media queries
    has_dark_query = Color.has_meaningful_color_scheme_query?(html_tree, raw_html, "dark")
    has_light_query = Color.has_meaningful_color_scheme_query?(html_tree, raw_html, "light")
    
    cond do
      # Truly chaotic evil: light in dark AND dark in light
      light_in_dark && dark_in_light ->
        []
        
      # Just light in dark mode is also chaotic
      light_in_dark ->
        []
        
      # Just dark in light mode is also chaotic
      dark_in_light ->
        []
        
      # No media query at all
      !has_dark_query && !has_light_query ->
        ["Page doesn't meaningfully use prefers-color-scheme media queries"]
        
      # Has queries but no chaotic behavior
      true ->
        ["Page properly matches color scheme to user preference"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: :platinum,
      title: "Chaotic Evil",
      group: "seared_retinas",
      description: "The primary background color is light when the user prefers dark mode and dark when the user prefers light mode"
    }
  end
end
