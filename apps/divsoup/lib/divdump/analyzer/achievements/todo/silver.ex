defmodule Divsoup.Achievement.TodoSilver do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_, raw_html_string) do
    todo_count =
      raw_html_string
      |> String.downcase()
      |> String.split("todo")
      |> length()

    if todo_count >= 3 do
      []
    else
      ["Page contains the phrase \"TODO\" #{todo_count} times"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :silver,
      title: "Fix me, please",
      group: "htmx",
      description: "Page contains the phrase \"TODO\" at least 3 times"
    }
  end
end
