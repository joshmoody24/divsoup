defmodule Divsoup.Achievement.TestInProd do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_html_tree, raw_html) do
    # Check for console.log statements in scripts
    if has_console_log?(raw_html) do
      []
    else
      ["No console.log statements found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Test in Prod",
      group: "test_in_prod",
      description: "Page contains console.log statements"
    }
  end
  
  defp has_console_log?(html) do
    # Match both console.log and console.log() with various possible arguments
    console_log_pattern = ~r/console\.log\s*\(/
    Regex.match?(console_log_pattern, html)
  end
end