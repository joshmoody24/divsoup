defmodule Divsoup.Achievement.SoapBox do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule
  @min_word_count 100

  @impl true
  def evaluate(_html_tree, raw_html) do
    # Find long comments in HTML
    long_comments = find_long_comments(raw_html)
    
    if Enum.any?(long_comments) do
      []
    else
      ["No HTML comment with more than #{@min_word_count} words found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "Soap Box",
      group: "soap_box",
      description: "Page contains an HTML <code>&lt;!-- comment --&gt;</code> with more than <strong>100</strong> words"
    }
  end
  
  defp find_long_comments(html) do
    # Find all HTML comments
    comment_pattern = ~r/<!--([\s\S]*?)-->/
    comments = Regex.scan(comment_pattern, html, capture: :all_but_first)
    
    # Check each comment for word count
    comments
    |> List.flatten()
    |> Enum.filter(fn comment ->
      # Count words by splitting on whitespace
      word_count = 
        comment
        |> String.trim()
        |> String.split(~r/\s+/)
        |> length()
        
      word_count > @min_word_count
    end)
  end
end