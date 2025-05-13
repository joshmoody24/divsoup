defmodule Divsoup.Achievement.SemanticSnobGold do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule
  @required_elements ["header", "nav", "main", "article", "section", "aside", "footer"]

  @impl true
  def evaluate(html_tree, _) do
    # Check for presence of all required semantic elements
    missing_elements =
      @required_elements
      |> Enum.filter(fn element ->
        Floki.find(html_tree, element) == []
      end)

    if Enum.empty?(missing_elements) do
      []
    else
      ["Missing semantic elements: #{Enum.join(missing_elements, ", ")}"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :gold,
      title: "Semantic Snob",
      group: "semantic_snob",
      description: "Page uses each of the following elements: <header>, <nav>, <main>, <article>, <section>, <aside>, <footer>"
    }
  end
end