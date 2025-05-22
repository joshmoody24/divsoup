defmodule Divsoup.Achievement.CommentatorInChief do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_html_tree, raw_html) do
    # Count HTML comments in the raw HTML string
    comment_count = count_comments(raw_html)

    if comment_count > 10 do
      []
    else
      ["Only #{comment_count} HTML comments found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Commentator-in-Chief",
      group: "commentator_in_chief",
      description: "Page has more than 10 <!-- comments -->"
    }
  end

  defp count_comments(html) do
    # Use regex to find all HTML comments
    ~r/<!--([\s\S]*?)-->/
    |> Regex.scan(html)
    |> length()
  end
end