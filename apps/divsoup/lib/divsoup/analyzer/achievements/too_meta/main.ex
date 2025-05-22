defmodule Divsoup.Achievement.TooMeta do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Find head element
    head = Floki.find(html_tree, "head")

    # Find meta elements in the head
    meta_elements = Floki.find(head, "meta")
    meta_count = length(meta_elements)

    if meta_count >= 8 do
      []
    else
      ["Only #{meta_count} meta elements found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Too Meta",
      group: "too_meta",
      description: "Page <code>&lt;head&gt;</code> includes <strong>8+</strong> <code>&lt;meta&gt;</code> elements"
    }
  end
end

