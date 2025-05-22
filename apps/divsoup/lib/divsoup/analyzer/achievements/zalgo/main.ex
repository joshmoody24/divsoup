defmodule Divsoup.Achievement.Zalgo do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_html_tree, raw_html) do
    # Count instances of Zalgo text (corrupted Unicode combining characters)
    # Zalgo text typically uses excessive combining diacritical marks stacked on characters
    
    # Pattern for finding sequences with multiple combining characters (diacritical marks)
    # Unicode ranges for combining diacritical marks:
    # - U+0300 to U+036F (Combining Diacritical Marks)
    # - U+1AB0 to U+1AFF (Combining Diacritical Marks Extended)
    # - U+1DC0 to U+1DFF (Combining Diacritical Marks Supplement)
    # - U+20D0 to U+20FF (Combining Diacritical Marks for Symbols)
    # - U+FE20 to U+FE2F (Combining Half Marks)
    
    # Look for instances of character followed by at least 3 combining marks
    zalgo_pattern = ~r/[^\p{M}][\p{M}]{3,}/u
    zalgo_sequences = Regex.scan(zalgo_pattern, raw_html)
    
    zalgo_count = length(zalgo_sequences)
    
    if zalgo_count > 0 do
      # Achievement earned with any Zalgo text
      []
    else
      ["Page does not contain any Zalgo text"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Zalgo",
      group: "zalgo",
      description: "Page contains <strong>Zalgo</strong> text (corrupted Unicode with combining characters)"
    }
  end
end