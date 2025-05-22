defmodule Divsoup.Achievement.BulletHell do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  # Unicode bullet characters
  @bullet_chars [
    "•", "·", "●", "○", "◆", "◇", "■", "□", "▪", "▫", "▶", "►", "▸", "▹", "▼", "▽", "▾", "▿",
    "◘", "◙", "◦", "★", "☆", "✓", "✔", "✗", "✘", "⁃", "⁕", "⁎", "⁍", "⦿", "⦾", "⧫", "⧮"
  ]

  @impl true
  def evaluate(html_tree, _) do
    # Check if there's a HTML list in the page
    html_list_elements = Floki.find(html_tree, "ul, ol")
    
    # Method 1: Check for consecutive elements that start with bullets
    consecutive_bullet_elements =
      Floki.find(html_tree, "p, div, span, h1, h2, h3, h4, h5, h6")
      |> Enum.map(fn elem -> String.trim(Floki.text(elem)) end)
      |> Enum.filter(fn text -> 
        Enum.any?(@bullet_chars, fn bullet -> 
          String.starts_with?(text, bullet) 
        end)
      end)
    
    # Method 2: Check for text content with multiple bullet points on new lines
    text_with_bullets =
      Floki.find(html_tree, "*")
      |> Enum.filter(fn 
        {tag, _, _} -> tag not in ["ul", "ol", "li"] 
        _ -> false
      end)
      |> Enum.map(&Floki.text/1)
      |> Enum.any?(fn text ->
        lines = String.split(text, ~r/\r?\n/)
        bullet_lines = Enum.filter(lines, fn line ->
          trimmed = String.trim(line)
          Enum.any?(@bullet_chars, fn bullet -> 
            String.starts_with?(trimmed, bullet)
          end)
        end)
        length(bullet_lines) >= 2
      end)
    
    has_bullet_list = length(consecutive_bullet_elements) >= 2 or text_with_bullets
    
    if has_bullet_list and length(html_list_elements) == 0 do
      []
    else
      ["Page does not use unicode bullet points to create a list instead of <ul> elements"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Bullet Hell",
      group: "bullet_hell",
      description: "Page uses unicode bullet points (• ◆ ★) to create a list instead of using <code>&lt;ul&gt;</code>"
    }
  end
end