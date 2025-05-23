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
      description: "Page contains an ASCII art HTML <code>&lt;!-- comment --&gt;</code>"
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
  # 1) if the comment is blank (or only spaces/newlines), it's not code
  trimmed = String.trim(comment)
  if trimmed == "" do
    false
  else
    # 2) “definitive code markers” check stays the same
    definitive_code_markers = ["[if", "function", "var ", "class=", "<script", "</script>", "<![endif]"]
    if Enum.any?(definitive_code_markers, &String.contains?(trimmed, &1)) do
      true
    else
      # split out the non-empty lines
      lines =
        trimmed
        |> String.split("\n")
        |> Enum.map(&String.trim/1)
        |> Enum.reject(&(&1 == ""))

      cond do
        # 3) if we have 3 or more lines, use the “art‐like lines” ratio
        length(lines) >= 3 ->
          art_symbols = ["/", "\\", "|", "-", "_", "+", "=", ">", "<", "^", "(", ")"]
          art_like =
            Enum.count(lines, fn line ->
              content = String.replace(line, " ", "")
              len = String.length(content)
              # only test non-empty content
              len > 0 and
                (Enum.sum(
                   for sym <- art_symbols do
                     String.graphemes(content) |> Enum.count(&(&1 == sym))
                   end
                 ) / len) > 0.3
            end)

          # safe because length(lines) >= 3
          art_like / length(lines) < 0.33

        # 4) fewer than 3 lines, fall back to alphanumeric‐dominance
        true ->
          # strip *all* whitespace
          raw = String.replace(trimmed, ~r/\s/, "")
          raw_len = String.length(raw)

          # never divide if raw_len == 0
          if raw_len == 0 do
            false
          else
            alpha_count = Regex.replace(~r/[^a-zA-Z0-9]/, raw, "") |> String.length()
            (alpha_count / raw_len) > 0.7
          end
      end
    end
  end
end
end

