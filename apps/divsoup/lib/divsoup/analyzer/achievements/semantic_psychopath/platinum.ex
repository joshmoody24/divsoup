defmodule Divsoup.Achievement.SemanticPsychopathPlatinum do
  alias Divsoup.Achievement
  alias Divsoup.Achievement.SemanticSnobGold

  @behaviour Divsoup.AchievementRule
  @forbidden_elements ["div", "span"]

  @impl true
  def evaluate(html_tree, raw_html) do
    # First check if SemanticSnob criteria are met
    semantic_snob_errors = SemanticSnobGold.evaluate(html_tree, raw_html)

    if semantic_snob_errors != [] do
      semantic_snob_errors
    else
      # Then check if there are no div or span elements
      forbidden_elements_present =
        @forbidden_elements
        |> Enum.filter(fn element ->
          Floki.find(html_tree, element) != []
        end)

      if Enum.empty?(forbidden_elements_present) do
        []
      else
        ["Contains forbidden elements: #{Enum.join(forbidden_elements_present, ", ")}"]
      end
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :platinum,
      title: "Semantic Psychopath",
      group: "semantic_psychopath",
      description: "Fulfill the criteria for Semantic Snob and also do not use a single <code>&lt;div&gt;</code> or <code>&lt;span&gt;</code>"
    }
  end
end