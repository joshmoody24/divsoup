defmodule Divsoup.Achievement.ScriptoniteSilver do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    script_tags = Floki.find(html_tree, "script")

    on_attributes =
      Floki.find(html_tree, "*")
      |> Enum.filter(fn
        {_, attrs, _} -> Enum.any?(attrs, fn {attr, _} -> String.starts_with?(attr, "on") end)
        _ -> false
      end)

    []
    |> add_if(length(script_tags) > 0, "Contains <script> tags")
    |> add_if(
      length(on_attributes) > 0,
      "Contains inline JavaScript attributes (e.g., onclick, onload, etc.)"
    )
  end

  defp add_if(errors, condition, message) do
    if condition, do: [message | errors], else: errors
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :silver,
      title: "Scriptonite",
      group: "scriptonite",
      description: "No <script> tags or on* attributes appear in the page"
    }
  end
end
