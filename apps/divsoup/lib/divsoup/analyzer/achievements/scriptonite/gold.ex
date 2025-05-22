defmodule Divsoup.Achievement.ScriptoniteGold do
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

    css_inline =
      Floki.find(html_tree, "*")
      |> Enum.filter(fn
        {_, attrs, _} -> Enum.any?(attrs, fn {attr, _} -> attr == "style" end)
        _ -> false
      end)

    style_elements = Floki.find(html_tree, "style")
    css_tags = Floki.find(html_tree, "link[rel=\"stylesheet\"]") ++ style_elements
    image_tags = Floki.find(html_tree, "img")

    []
    |> add_if(length(script_tags) > 0, "Contains <script> tags")
    |> add_if(
      length(on_attributes) > 0,
      "Contains inline JavaScript event attributes (e.g., onclick, onload)"
    )
    |> add_if(length(css_inline) > 0, "Uses inline CSS via the style attribute")
    |> add_if(length(style_elements) > 0, "Includes <style> blocks with embedded CSS")
    |> add_if(length(css_tags) > 0, "Loads external or embedded stylesheets")
    |> add_if(
      length(image_tags) > 0,
      "Includes <img> elements which are not visible in text-based browsers like Lynx"
    )
  end

  defp add_if(errors, condition, message) do
    if condition, do: [message | errors], else: errors
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :gold,
      title: "i use lynx btw",
      group: "the_web_is_for_documents",
      description: "No JavaScript, CSS, or images appear in the page"
    }
  end
end
