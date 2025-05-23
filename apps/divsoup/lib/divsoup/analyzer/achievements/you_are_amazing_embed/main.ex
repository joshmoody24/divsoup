defmodule Divsoup.Achievement.YouAreAmazingEmbed do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _) do
    has_embed = Floki.find(html_tree, "object, embed, iframe")

    if length(has_embed) > 0 do
      []
    else
      ["No <object>, <embed>, or <iframe> elements found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Incredible Embed",
      group: "embed",
      description: "Page embeds external content via <code>&lt;object&gt;</code>, <code>&lt;embed&gt;</code>, or <code>&lt;iframe&gt;</code>"
    }
  end
end
