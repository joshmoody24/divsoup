defmodule Divsoup.Achievement.LocalityOfAppearance do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    if more_styles_than_classes(html_tree) do
      []
    else
      ["Page has more classes than styles"]
    end
  end

  defp more_styles_than_classes(html_tree) do
    classes_size =
      Floki.find(html_tree, "*[class]")
      |> Enum.map(&Floki.attribute(&1, "class"))
      |> Enum.join(" ")
      |> String.length()

    styles_size =
      Floki.find(html_tree, "*[style]")
      |> Enum.map(&Floki.attribute(&1, "style"))
      |> Enum.join(" ")
      |> String.length()

    styles_size > classes_size
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Locality of Appearance",
      group: "locality_of_appearance",
      description: "Page has more CSS in <code>style</code> attributes than <code>class</code> attributes"
    }
  end
end
