defmodule Divsoup.Achievement.NaturalLanguageStaticTyping do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Find input or textarea elements with spellcheck="true"
    spellcheck_inputs = Floki.find(html_tree, "input[spellcheck=\"true\"], textarea[spellcheck=\"true\"]")
    
    if length(spellcheck_inputs) > 0 do
      []
    else
      ["No text inputs or textareas with spellcheck=\"true\" found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Natural Language Static Typing",
      group: "semistatic_types",
      description: "At least one text input (or textarea) has <code>spellcheck=\"true\"</code>"
    }
  end
end
