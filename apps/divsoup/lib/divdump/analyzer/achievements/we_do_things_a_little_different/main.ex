defmodule Divsoup.Achievement.WeDoThingsALittleDifferent do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Find span elements that contain div elements
    divs_in_spans = 
      Floki.find(html_tree, "span")
      |> Enum.filter(fn span ->
        span 
        |> Floki.find("div") 
        |> Enum.any?()
      end)
    
    if length(divs_in_spans) > 0 do
      []
    else
      ["No div nested inside a span found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "We Do Things a Little Different Around Here",
      group: "we_do_things_a_little_different",
      description: "Nest a <div> inside a <span>"
    }
  end
end