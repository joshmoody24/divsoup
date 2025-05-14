defmodule Divsoup.Achievement.BobRoss do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Check for <canvas> or <picture> elements
    canvas_elements = Floki.find(html_tree, "canvas")
    picture_elements = Floki.find(html_tree, "picture")

    if length(canvas_elements) > 0 or length(picture_elements) > 0 do
      []
    else
      ["Page does not include a <canvas> element or <picture> element"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Bob Ross",
      group: "bob_ross",
      description: "Page includes a <canvas> or <picture> element"
    }
  end
end

