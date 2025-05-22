defmodule Divsoup.Achievement.ImportantPerson do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_html_tree, raw_html) do
    # Count occurrences of !important in the raw HTML
    important_count = count_important_occurrences(raw_html)
    if important_count >= 10 do
      []
    else
      ["Only #{important_count} !important declarations found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "!important person",
      group: "important_person",
      description: "The phrase <code>!important</code> appears <strong>10</strong> or more times on the page"
    }
  end
  
  defp count_important_occurrences(html) do
    ~r/\!important/i
    |> Regex.scan(html)
    |> length()
  end
end
