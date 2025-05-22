defmodule Divsoup.AchievementTest.Helper do
  @moduledoc """
  Helper functions for testing achievements.
  """

  @doc """
  Helper function to test that an achievement is earned when given specific HTML.
  
  ## Parameters
  - `achievement_module`: The module implementing the achievement rule
  - `html`: The HTML string that should earn the achievement
  """
  def assert_achievement_earned(achievement_module, html) do
    # Add a debug printout to help with troubleshooting
    {:ok, html_tree} = Floki.parse_document(html)
    
    # Debug count of elements and divs
    div_count = Floki.find(html_tree, "div") |> length()
    total_count = Floki.find(html_tree, "*") |> length()
    ratio = div_count / total_count

    IO.puts("DEBUG: #{achievement_module} - Divs: #{div_count}, Total: #{total_count}, Ratio: #{ratio}")
    
    errors = achievement_module.evaluate(html_tree, html)
    
    # If the achievement is earned, errors should be an empty list
    ExUnit.Assertions.assert errors == [], 
      "Expected achievement to be earned, but got errors: #{inspect(errors)}"
  end

  @doc """
  Helper function to test that an achievement is not earned when given specific HTML.
  
  ## Parameters
  - `achievement_module`: The module implementing the achievement rule
  - `html`: The HTML string that should not earn the achievement
  """
  def assert_achievement_not_earned(achievement_module, html) do
    {:ok, html_tree} = Floki.parse_document(html)
    
    # Debug count of elements and divs
    div_count = Floki.find(html_tree, "div") |> length()
    total_count = Floki.find(html_tree, "*") |> length()
    ratio = div_count / total_count

    IO.puts("DEBUG: #{achievement_module} - Divs: #{div_count}, Total: #{total_count}, Ratio: #{ratio}")
    
    errors = achievement_module.evaluate(html_tree, html)
    
    # If the achievement is not earned, errors should be a non-empty list
    ExUnit.Assertions.assert errors != [], 
      "Expected achievement to not be earned, but got no errors"
  end
end
