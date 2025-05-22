defmodule Divsoup.Achievement.LoremIpsum do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    if Floki.find(html_tree, "body")
       |> Floki.text()
       |> String.downcase()
       |> String.contains?("lorem ipsum") do
      []
    else
      ["Page does not contain the text \"lorem ipsum\""]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Textus Vicarious",
      group: "lorem_ipsum",
      description: "Pagina locutionem \"lorem ipsum\" continet"
    }
  end
end
