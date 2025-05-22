defmodule Divsoup.Achievement.ClassWarfare do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    # Find all elements with class attributes
    elements_with_classes = Floki.find(html_tree, "*[class]")
    
    # Check if any element has more than 50 classes
    has_many_classes = 
      elements_with_classes
      |> Enum.any?(fn element ->
        element
        |> Floki.attribute("class")
        |> List.first("")
        |> String.split()
        |> length() > 50
      end)
    
    if has_many_classes do
      []
    else
      ["No element with more than 50 classes found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Class Warfare",
      group: "class_warfare",
      description: "Page includes an element with more than <strong>50</strong> classes"
    }
  end
end
