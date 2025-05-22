defmodule Divsoup.Util.Color do
  @moduledoc """
  Utility functions for analyzing color schemes and preferences in HTML.
  """

  @doc """
  Map of common CSS color keywords to their hex values.
  Only includes the most common colors as per requirements.
  """
  def color_keywords do
    %{
      # Light colors
      "white" => "#FFFFFF",
      "ivory" => "#FFFFF0",
      "snow" => "#FFFAFA",
      "whitesmoke" => "#F5F5F5",
      "seashell" => "#FFF5EE",
      "ghostwhite" => "#F8F8FF",
      "azure" => "#F0FFFF",

      # Dark colors
      "black" => "#000000",
      "darkslategray" => "#2F4F4F",
      "darkslategrey" => "#2F4F4F",
      "dimgray" => "#696969",
      "dimgrey" => "#696969",
      "slategray" => "#708090",
      "slategrey" => "#708090"
    }
  end

  @doc """
  Convert color keyword to hex code if it's a known keyword.
  Returns the original input if it's not a recognized keyword or already a hex code.

  ## Parameters
  - `color_value`: Color as string (keyword or hex code)

  ## Returns
  - Hex code as string
  """
  def normalize_color(color_value) when is_binary(color_value) do
    color = String.trim(color_value) |> String.downcase()

    cond do
      # Already a hex code
      String.starts_with?(color, "#") ->
        color

      # Known keyword
      Map.has_key?(color_keywords(), color) ->
        Map.get(color_keywords(), color)

      # RGB format
      String.starts_with?(color, "rgb") ->
        parse_rgb_to_hex(color)

      # Unknown color
      true ->
        # Default to white
        "#FFFFFF"
    end
  end

  @doc """
  Calculate the brightness of a color (0 to 1 scale).

  ## Parameters
  - `color`: Color as hex code string (e.g., "#FFFFFF")

  ## Returns
  - Brightness value between 0 (darkest) and 1 (brightest)
  """
  def calculate_brightness(color) when is_binary(color) do
    hex = normalize_color(color)

    # Parse hex values
    {r, g, b} = hex_to_rgb(hex)

    # Apply brightness formula: (0.299*R + 0.587*G + 0.114*B)/255
    (0.299 * r + 0.587 * g + 0.114 * b) / 255
  end

  @doc """
  Check if a color is considered light (brightness > 0.7).

  ## Parameters
  - `color`: Color as hex code string or keyword

  ## Returns
  - `true` if the color is light, `false` otherwise
  """
  def is_light_color?(color) when is_binary(color) do
    calculate_brightness(color) > 0.7
  end

  @doc """
  Check if a color is considered dark (brightness < 0.3).

  ## Parameters
  - `color`: Color as hex code string or keyword

  ## Returns
  - `true` if the color is dark, `false` otherwise
  """
  def is_dark_color?(color) when is_binary(color) do
    calculate_brightness(color) < 0.3
  end

  @doc """
  Extract background color from HTML for a given color scheme.

  ## Parameters
  - `html_tree`: Floki parsed HTML tree
  - `_raw_html`: Raw HTML string (unused but kept for API consistency)
  - `color_scheme`: Either `:light` or `:dark` (optional)

  ## Returns
  - Background color as hex code string, or nil if not found
  """
  def extract_background_color(html_tree, _raw_html, color_scheme \\ nil) do
    # Extract all style elements content
    style_content =
      Floki.find(html_tree, "style")
      |> Enum.map(&Floki.text/1)
      |> Enum.join(" ")

    # Find all inline styles on html and body
    html_style =
      case Floki.find(html_tree, "html[style]") do
        [] ->
          ""

        [{_, attrs, _} | _] ->
          attrs |> Enum.into(%{}) |> Map.get("style", "")
      end

    body_style =
      case Floki.find(html_tree, "body[style]") do
        [] ->
          ""

        [{_, attrs, _} | _] ->
          attrs |> Enum.into(%{}) |> Map.get("style", "")
      end

    all_css = style_content <> " " <> html_style <> " " <> body_style

    # Check for specific color scheme in media queries if requested
    background_color =
      case color_scheme do
        :dark -> extract_from_media_query(all_css, "dark")
        :light -> extract_from_media_query(all_css, "light")
        _ -> nil
      end

    # If we found a color in media query, return it
    if background_color do
      background_color
    else
      # Otherwise look for general background color
      extract_general_background(html_style, body_style, style_content)
    end
  end

  @doc """
  Check if the page has proper support for dark mode.

  ## Parameters
  - `html_tree`: Floki parsed HTML tree
  - `raw_html`: Raw HTML string

  ## Returns
  - `true` if the page has dark mode support, `false` otherwise
  """
  def has_dark_mode_support?(html_tree, raw_html) do
    # Check for dark mode media query
    has_query = has_dark_mode_query?(html_tree, raw_html)

    if has_query do
      # Extract background color in dark mode
      dark_bg = extract_background_color(html_tree, raw_html, :dark)

      # Check if dark mode actually uses a dark background
      dark_bg && is_dark_color?(dark_bg)
    else
      false
    end
  end

  @doc """
  Check if the HTML has a dark mode media query.

  ## Parameters
  - `html_tree`: Floki parsed HTML tree
  - `raw_html`: Raw HTML string

  ## Returns
  - `true` if a dark mode media query exists, `false` otherwise
  """
  def has_dark_mode_query?(html_tree, raw_html) do
    # Extract all style elements content
    style_content =
      Floki.find(html_tree, "style")
      |> Enum.map(&Floki.text/1)
      |> Enum.join(" ")

    # Check both the style tags and the raw HTML for media queries
    Regex.match?(~r/@media\s*\(\s*prefers-color-scheme\s*:\s*dark\s*\)/i, style_content) ||
      Regex.match?(~r/prefers-color-scheme\s*:\s*dark/i, raw_html)
  end

  @doc """
  Check if the HTML has a light mode media query.

  ## Parameters
  - `html_tree`: Floki parsed HTML tree
  - `raw_html`: Raw HTML string

  ## Returns
  - `true` if a light mode media query exists, `false` otherwise
  """
  def has_light_mode_query?(html_tree, raw_html) do
    # Extract all style elements content
    style_content =
      Floki.find(html_tree, "style")
      |> Enum.map(&Floki.text/1)
      |> Enum.join(" ")

    # Check both the style tags and the raw HTML for media queries
    Regex.match?(~r/@media\s*\(\s*prefers-color-scheme\s*:\s*light\s*\)/i, style_content) ||
      Regex.match?(~r/prefers-color-scheme\s*:\s*light/i, raw_html)
  end

  @doc """
  Check if the page uses light background in dark mode.

  ## Parameters
  - `html_tree`: Floki parsed HTML tree
  - `raw_html`: Raw HTML string

  ## Returns
  - `true` if the page uses light background in dark mode, `false` otherwise
  """
  def has_light_in_dark_mode?(html_tree, raw_html) do
    if has_dark_mode_query?(html_tree, raw_html) do
      dark_bg = extract_background_color(html_tree, raw_html, :dark)
      dark_bg && is_light_color?(dark_bg)
    else
      false
    end
  end

  @doc """
  Check if the page uses dark background in light mode.

  ## Parameters
  - `html_tree`: Floki parsed HTML tree
  - `raw_html`: Raw HTML string

  ## Returns
  - `true` if the page uses dark background in light mode, `false` otherwise
  """
  def has_dark_in_light_mode?(html_tree, raw_html) do
    if has_light_mode_query?(html_tree, raw_html) do
      light_bg = extract_background_color(html_tree, raw_html, :light)
      light_bg && is_dark_color?(light_bg)
    else
      false
    end
  end

  # Extract color from a media query for a given scheme
  defp extract_from_media_query(css, scheme) do
    # Try to find background-color within the media query
    regex =
      ~r/@media\s*\(\s*prefers-color-scheme\s*:\s*#{scheme}\s*\)[^{]*{[^}]*(background(-color)?:\s*([^;]*))/i

    case Regex.run(regex, css) do
      [_, _, _, color_value] -> normalize_color(color_value)
      _ -> nil
    end
  end

  # Extract general background color (not in a media query)
  defp extract_general_background(html_style, body_style, style_content) do
    # Try inline styles first (html and body elements)
    html_bg = extract_from_style(html_style)
    body_bg = extract_from_style(body_style)

    # Then try CSS rules in style tags
    css_bg =
      case Regex.run(~r/body\s*{[^}]*(background(-color)?:\s*([^;]*))/i, style_content) do
        [_, _, _, color_value] -> normalize_color(color_value)
        _ -> nil
      end

    # Then try html element
    html_css_bg =
      case Regex.run(~r/html\s*{[^}]*(background(-color)?:\s*([^;]*))/i, style_content) do
        [_, _, _, color_value] -> normalize_color(color_value)
        _ -> nil
      end

    # Use the first one we find (priority: html inline, body inline, body css, html css)
    html_bg || body_bg || css_bg || html_css_bg
  end

  # Extract color from inline style
  defp extract_from_style(style) do
    case Regex.run(~r/background(-color)?:\s*([^;]*)/i, style) do
      [_, _, color_value] -> normalize_color(color_value)
      _ -> nil
    end
  end

  # Parse hex code to RGB values
  defp hex_to_rgb(hex) do
    hex = String.replace(hex, ~r/^#/, "")

    # Handle both #RGB and #RRGGBB formats
    {r, g, b} =
      case String.length(hex) do
        3 ->
          # Convert #RGB to #RRGGBB
          [r, g, b] = String.codepoints(hex)

          {
            String.to_integer(r <> r, 16),
            String.to_integer(g <> g, 16),
            String.to_integer(b <> b, 16)
          }

        6 ->
          {
            String.to_integer(String.slice(hex, 0, 2), 16),
            String.to_integer(String.slice(hex, 2, 2), 16),
            String.to_integer(String.slice(hex, 4, 2), 16)
          }

        _ ->
          # Default to white for invalid hex
          {255, 255, 255}
      end

    {r, g, b}
  end

  # Parse rgb()/rgba() format to hex
  defp parse_rgb_to_hex(rgb_str) do
    # Extract RGB values using regex
    case Regex.run(~r/rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/i, rgb_str) do
      [_, r, g, b] ->
        r = String.to_integer(r) |> min(255) |> max(0)
        g = String.to_integer(g) |> min(255) |> max(0)
        b = String.to_integer(b) |> min(255) |> max(0)

        # Convert to hex
        "#" <> Integer.to_string(r, 16) <> Integer.to_string(g, 16) <> Integer.to_string(b, 16)

      _ ->
        # Try percentage format
        case Regex.run(~r/rgba?\(\s*(\d+)%\s*,\s*(\d+)%\s*,\s*(\d+)%/i, rgb_str) do
          [_, r, g, b] ->
            r = (String.to_integer(r) * 255 / 100) |> round |> min(255) |> max(0)
            g = (String.to_integer(g) * 255 / 100) |> round |> min(255) |> max(0)
            b = (String.to_integer(b) * 255 / 100) |> round |> min(255) |> max(0)

            # Convert to hex
            "#" <>
              Integer.to_string(r, 16) <> Integer.to_string(g, 16) <> Integer.to_string(b, 16)

          _ ->
            # Default to white
            "#FFFFFF"
        end
    end
  end
end

