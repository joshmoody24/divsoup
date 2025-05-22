defmodule Divsoup.Achievement.TodoBronze do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_, raw_html_string) do
    contains_todo = raw_html_string |> String.upcase() |> String.contains?("TODO")

    case contains_todo do
      true ->
        []

      false ->
        ["The phrase \"TODO\" does not appear in the page"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :bronze,
      title: "Unfinished Business",
      group: "htmx",
      description: "Page contains the phrase \"TODO\""
    }
  end
end
