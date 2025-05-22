defmodule Divsoup.Achievement.MillionthVisitor do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    blink_count = Floki.find(html_tree, "blink") |> length()
    marquee_count = Floki.find(html_tree, "marquee") |> length()

    messages =
      []
      |> add_if(
        blink_count == 0 and marquee_count == 0,
        "Page does not use a <blink> or <marquee> element"
      )

    messages
  end

  defp add_if(list, condition, message) do
    if condition do
      [message | list]
    else
      list
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Millionth Visitor!!!",
      group: "millionth_visitor",
      description: "Page uses a <code>&lt;blink&gt;</code> or <code>&lt;marquee&gt;</code> element"
    }
  end
end
