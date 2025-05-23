ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Divsoup.Repo, :manual)

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
    {:ok, html_tree} = Floki.parse_document(html)
    errors = achievement_module.evaluate(html_tree, html)

    ExUnit.Assertions.assert(
      errors == [],
      "Expected achievement to be earned, but got errors: #{inspect(errors)}"
    )
  end

  @doc """
  Helper function to test that an achievement is not earned when given specific HTML.

  ## Parameters
  - `achievement_module`: The module implementing the achievement rule
  - `html`: The HTML string that should not earn the achievement
  """
  def assert_achievement_not_earned(achievement_module, html) do
    {:ok, html_tree} = Floki.parse_document(html)
    errors = achievement_module.evaluate(html_tree, html)
    # If the achievement is not earned, errors should be a non-empty list
    ExUnit.Assertions.assert(
      errors != [],
      "Expected achievement to not be earned, but got no errors"
    )
  end
end

