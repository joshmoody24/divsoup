defmodule Divsoup.Achievement.AsciiArt do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_html_tree, raw_html) do
    # Check for ASCII art in HTML comments
    if has_ascii_art_comment?(raw_html) do
      []
    else
      ["No ASCII art HTML comment found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "ASCII Art",
      group: "ascii_art",
      description: "Page contains an ASCII art HTML comment"
    }
  end
  
  defp has_ascii_art_comment?(html) do
    # Find all HTML comments
    comment_pattern = ~r/<!--([\s\S]*?)-->/
    comments = Regex.scan(comment_pattern, html, capture: :all_but_first)
    
    # Check each comment for ASCII art patterns
    comments
    |> List.flatten()
    |> Enum.any?(fn comment ->
      # ASCII art typically has repeated special characters in patterns 
      # and multiple consecutive lines with similar structure
      is_ascii_art?(comment)
    end)
  end
  
  defp is_ascii_art?(comment) do
    lines = 
      comment
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))
    
    # Enhanced criteria for ASCII art:
    # 1. At least 3 non-empty lines, OR
    # 2. Contains common ASCII art patterns, OR
    # 3. Has sufficient density of special characters
    
    lines_count = length(lines)
    
    # More comprehensive list of ASCII art characters
    ascii_art_chars = ["+", "-", "|", "/", "\\", "*", "=", ">", "<", "^", "(", ")", "[", "]", "{", "}", "_", ".", ":", ";", "'", "`", "~", "#", "@"]
    
    # Common ASCII art patterns (bunny, faces, boxes, etc.)
    ascii_art_patterns = [
      ~r/\(\s*[oO0\-_\^\\\/]\s*[_.,-]\s*[oO0\-_\^\\\/]\s*\)/,  # Face patterns like (o.o), (^_^)
      ~r/[<>]\s*[\^v\-_]\s*[<>]/,                             # Face patterns like >_<, <^>
      ~r/\+[-_=]+\+/,                                         # Box top/bottom like +----+
      ~r/\|[^|]{2,}\|/,                                       # Box sides like |  text  |
      ~r/\/[\\\/]/,                                           # Slashes like /\, //
      ~r/[_~\-=]{3,}/,                                        # Repeated horizontal lines
      ~r/[|:]{2,}/,                                           # Repeated vertical lines
      ~r/[\/\\]{2,}/,                                         # Repeated slashes
      ~r/\\\\_\/\\\\/                                         # Bunny ears pattern
    ]
    
    # Join all lines
    text = Enum.join(lines, " ")
    
    # Check for common patterns
    has_ascii_pattern = Enum.any?(ascii_art_patterns, fn pattern -> 
      Regex.match?(pattern, text)
    end)
    
    # Count special characters
    special_char_count = 
      ascii_art_chars
      |> Enum.map(fn char -> 
        text 
        |> String.graphemes 
        |> Enum.count(fn c -> c == char end)
      end)
      |> Enum.sum()
    
    # Calculate density of special characters
    text_length = String.length(text)
    special_char_density = if text_length > 0, do: special_char_count / text_length, else: 0
    
    # Different ASCII art characters present
    unique_special_chars = 
      ascii_art_chars
      |> Enum.filter(fn char -> String.contains?(text, char) end)
      |> length()
    
    # Determine if it's ASCII art based on various factors
    cond do
      # Has an obvious ASCII art pattern
      has_ascii_pattern -> true
      
      # Has at least 3 lines and good density of special chars
      lines_count >= 3 and special_char_density > 0.05 and unique_special_chars >= 3 -> true
      
      # Has many unique special characters
      unique_special_chars >= 6 -> true
      
      # Has high density of special characters
      special_char_density > 0.15 -> true
      
      # Not ASCII art
      true -> false
    end
  end
end