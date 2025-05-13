defmodule Divsoup.Achievement.Bigheaded do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule
  @min_head_elements 25

  @impl true
  def evaluate(html_tree, _) do
    # Count elements in the head
    head_elements = count_head_elements(html_tree)
    
    if head_elements >= @min_head_elements do
      []
    else
      ["Only #{head_elements} elements in head"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Bigheaded",
      group: "bigheaded",
      description: "Page head contains 25 or more elements"
    }
  end
  
  defp count_head_elements(html_tree) do
    # Find the head element
    head = Floki.find(html_tree, "head")
    
    # Count all child elements inside the head
    head
    |> Floki.find("*")
    |> length()
  end
end