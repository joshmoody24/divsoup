defmodule Divsoup.Achievement.Htmx do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    references_htmx = Floki.raw_html(html_tree) |> String.downcase() |> String.contains?("htmx")

    case references_htmx do
      true -> []
      false -> ["Page does not contain the phrase \"htmx\""]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "HTMX Simp",
      group: "htmx",
      description: "Page contains a reference to HTMX"
    }
  end
end
