defmodule Divsoup.Achievement.FrameworkPhobia do
  @moduledoc """
  Detects pages that define a custom element but don’t rely on a JS framework.

  Success (returns `[]`) when:
    • The page contains at least one custom element (`<x-foo>` syntax)  
    • No React/Angular/Vue/etc. frameworks are detected

  Otherwise, returns all reasons why the rule failed.
  """

  alias Divsoup.Achievement
  alias Divsoup.Util.WebFramework

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, raw_html_string) do
    frameworks = WebFramework.detected_web_frameworks(html_tree)
    has_custom = contains_custom_element?(raw_html_string)

    [
      !has_custom && "The page does not contain a custom element",
      frameworks != [] && "The page uses JS frameworks: " <> Enum.join(frameworks, ", ")
    ]
    |> Enum.filter(& &1)
  end

  defp contains_custom_element?(raw_html_string) do
    # matches e.g. `<my-widget>…</my-widget>`
    regex = ~r/<([A-Za-z0-9]+-[A-Za-z0-9]+)(\s+[^>]*)?>.*<\/\1>/
    Regex.match?(regex, raw_html_string)
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Framework Phobia",
      group: "framework_phobia",
      description: "The page contains a custom element and does not use a JS framework"
    }
  end
end
