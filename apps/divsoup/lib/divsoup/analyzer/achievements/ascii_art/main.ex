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
      description: "Page contains an <code>ASCII art</code> HTML <code>&lt;!-- comment --&gt;</code>"
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
    
    # First check for code-like patterns that indicate it's not ASCII art
    if is_likely_code?(comment) do
      false
    else
      # ASCII art must have at least 5 non-empty lines
      lines_count = length(lines)
      
      if lines_count < 5 do
        # Too few lines to be ASCII art
        false
      else
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
        
        # Determine if it's ASCII art based on various factors - 
        # require either pattern match or good density of special characters
        has_ascii_pattern || (special_char_density > 0.05 && unique_special_chars >= 3)
      end
    end
  end
  
  # Check if a comment likely contains code rather than ASCII art
  defp is_likely_code?(comment) do
    # Definitive code markers that aren't typically in ASCII art
    definitive_code_markers = [
      "[if", 
      "function",
      "var ",
      "class=",
      "<script",
      "</script>",
      "<![endif]"
    ]
    
    # Check if any definitive code markers are present
    has_code_markers = Enum.any?(definitive_code_markers, fn marker ->
      String.contains?(comment, marker)
    end)
    
    # If any code markers are found, it's likely code
    if has_code_markers do
      true
    else
      # Check for ASCII art-like lines
      lines = comment |> String.split("\n") |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == ""))
      
      # Need multiple lines to check for ASCII art patterns
      if length(lines) >= 3 do
        # ASCII art symbols (more limited, focused set)
        art_symbols = ["/", "\\", "|", "-", "_", "+", "=", ">", "<", "^", "(", ")"]
        
        # Count lines that have ASCII art characteristics
        art_like_lines = Enum.count(lines, fn line ->
          # Remove spaces to work with content only
          content = String.replace(line, " ", "")
          
          if String.length(content) > 0 do
            # Count art symbols
            symbol_count = Enum.sum(Enum.map(art_symbols, fn symbol ->
              String.graphemes(content) |> Enum.count(fn c -> c == symbol end)
            end))
            
            # Line is art-like if >30% of its content is art symbols
            symbol_count / String.length(content) > 0.3
          else
            false
          end
        end)
        
        # If more than 1/3 of lines look like ASCII art, it's probably not code
        art_like_ratio = art_like_lines / length(lines)
        art_like_ratio < 0.33
      else
        # Too few lines to analyze patterns, check alphanumeric dominance
        text = String.replace(comment, ~r/\s/, "")
        alphanumeric_count = Regex.replace(~r/[^a-zA-Z0-9]/, text, "") |> String.length()
        alphanumeric_ratio = alphanumeric_count / String.length(text)
        
        # Code is predominantly alphanumeric
        alphanumeric_ratio > 0.7
      end
    end
  end
end