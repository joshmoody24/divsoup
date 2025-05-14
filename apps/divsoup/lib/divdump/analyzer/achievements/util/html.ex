defmodule Divsoup.Util.Html do
  @moduledoc """
  Utility functions for HTML elements, including deprecated element detection.
  """

  @doc """
  Map of HTML elements and their status.
  Values can be:
  - :standard - Standard HTML element in current use
  - :deprecated - Deprecated element not for use in new websites
  - :experimental - Experimental element with changing behavior
  """
  def html_elements do
    %{
      "a" => :standard,
      "abbr" => :standard,
      "acronym" => :deprecated,
      "address" => :standard,
      "area" => :standard,
      "article" => :standard,
      "aside" => :standard,
      "audio" => :standard,
      "b" => :standard,
      "base" => :standard,
      "bdi" => :standard,
      "bdo" => :standard,
      "big" => :deprecated,
      "blockquote" => :standard,
      "body" => :standard,
      "br" => :standard,
      "button" => :standard,
      "canvas" => :standard,
      "caption" => :standard,
      "center" => :deprecated,
      "cite" => :standard,
      "code" => :standard,
      "col" => :standard,
      "colgroup" => :standard,
      "data" => :standard,
      "datalist" => :standard,
      "dd" => :standard,
      "del" => :standard,
      "details" => :standard,
      "dfn" => :standard,
      "dialog" => :standard,
      "dir" => :deprecated,
      "div" => :standard,
      "dl" => :standard,
      "dt" => :standard,
      "em" => :standard,
      "embed" => :standard,
      "fencedframe" => :experimental,
      "fieldset" => :standard,
      "figcaption" => :standard,
      "figure" => :standard,
      "font" => :deprecated,
      "footer" => :standard,
      "form" => :standard,
      "frame" => :deprecated,
      "frameset" => :deprecated,
      "h1" => :standard,
      "head" => :standard,
      "header" => :standard,
      "hgroup" => :standard, # Note: was deprecated, but reintroduced
      "hr" => :standard,
      "html" => :standard,
      "i" => :standard,
      "iframe" => :standard,
      "img" => :standard,
      "input" => :standard,
      "ins" => :standard,
      "kbd" => :standard,
      "label" => :standard,
      "legend" => :standard,
      "li" => :standard,
      "link" => :standard,
      "main" => :standard,
      "map" => :standard,
      "mark" => :standard,
      "marquee" => :deprecated,
      "menu" => :standard,
      "meta" => :standard,
      "meter" => :standard,
      "nav" => :standard,
      "nobr" => :deprecated,
      "noembed" => :deprecated,
      "noframes" => :deprecated,
      "noscript" => :standard,
      "object" => :standard,
      "ol" => :standard,
      "optgroup" => :standard,
      "option" => :standard,
      "output" => :standard,
      "p" => :standard,
      "param" => :deprecated,
      "picture" => :standard,
      "plaintext" => :deprecated,
      "pre" => :standard,
      "progress" => :standard,
      "q" => :standard,
      "rb" => :deprecated,
      "rp" => :standard,
      "rt" => :standard,
      "rtc" => :deprecated,
      "ruby" => :standard,
      "s" => :standard,
      "samp" => :standard,
      "script" => :standard,
      "search" => :standard,
      "section" => :standard,
      "select" => :standard,
      "selectedcontent" => :experimental,
      "slot" => :standard,
      "small" => :standard,
      "source" => :standard,
      "span" => :standard,
      "strike" => :deprecated,
      "strong" => :standard,
      "style" => :standard,
      "sub" => :standard,
      "summary" => :standard,
      "sup" => :standard,
      "table" => :standard,
      "tbody" => :standard,
      "td" => :standard,
      "template" => :standard,
      "textarea" => :standard,
      "tfoot" => :standard,
      "th" => :standard,
      "thead" => :standard,
      "time" => :standard,
      "title" => :standard,
      "tr" => :standard,
      "track" => :standard,
      "tt" => :deprecated,
      "u" => :standard,
      "ul" => :standard,
      "var" => :standard,
      "video" => :standard,
      "wbr" => :standard,
      "xmp" => :deprecated
    }
  end
  
  @doc """
  Get a list of all deprecated HTML elements.
  
  Returns a list of element names (strings).
  """
  def deprecated_elements do
    html_elements()
    |> Enum.filter(fn {_element, status} -> status == :deprecated end)
    |> Enum.map(fn {element, _status} -> element end)
  end
  
  @doc """
  Check if a given HTML element is deprecated.
  
  ## Parameters
  - element: Element name as a string
  """
  @spec is_deprecated?(String.t()) :: boolean()
  def is_deprecated?(element) do
    Map.get(html_elements(), element) == :deprecated
  end
  
  @doc """
  Get a list of all standard HTML elements.
  
  Returns a list of element names (strings).
  """
  def standard_elements do
    html_elements()
    |> Enum.filter(fn {_element, status} -> status == :standard end)
    |> Enum.map(fn {element, _status} -> element end)
  end
  
  @doc """
  Get a list of all HTML elements (standard, deprecated, and experimental).
  
  Returns a list of element names (strings).
  """
  def all_elements do
    html_elements() |> Map.keys()
  end
  
  @doc """
  Count the total number of standard HTML elements.
  
  Returns an integer representing the number of standard HTML elements.
  """
  def count_standard_elements do
    standard_elements() |> length()
  end
  
  @doc """
  Count the total number of all HTML elements (including deprecated and experimental).
  
  Returns an integer representing the total number of HTML elements.
  """
  def count_all_elements do
    all_elements() |> length()
  end
  
  @doc """
  Filter a list of element names to only include valid HTML elements.
  
  ## Parameters
  - `element_names`: List of element names as strings
  
  ## Returns
  - List of valid HTML element names (those that exist in the HTML spec)
  """
  def filter_valid_elements(element_names) do
    element_names
    |> Enum.filter(fn element -> Map.has_key?(html_elements(), element) end)
  end
  
  @doc """
  Count the number of valid HTML elements used in an HTML tree.
  
  ## Parameters
  - `html_tree`: Floki parsed HTML tree
  
  ## Returns
  - Count of unique valid HTML elements used in the tree
  """
  def count_valid_elements_used(html_tree) do
    Floki.find(html_tree, "*")
    |> Enum.map(fn {element, _, _} -> element end)
    |> Enum.uniq()
    |> filter_valid_elements()
    |> length()
  end
  
  @doc """
  Get all valid HTML elements used in an HTML tree.
  
  ## Parameters
  - `html_tree`: Floki parsed HTML tree
  
  ## Returns
  - Set of valid HTML element names used in the tree
  """
  def get_valid_elements_used(html_tree) do
    Floki.find(html_tree, "*")
    |> Enum.map(fn {element, _, _} -> element end)
    |> Enum.uniq()
    |> filter_valid_elements()
    |> MapSet.new()
  end
  
  @doc """
  List of HTML void elements (elements that cannot have content).
  """
  def void_elements do
    [
      "area",
      "base",
      "br",
      "col",
      "embed",
      "hr",
      "img",
      "input",
      "link",
      "meta",
      "source",
      "track",
      "wbr"
    ]
  end
  
  @doc """
  Analyze void elements in raw HTML to determine how they are closed.
  
  ## Parameters
  - `raw_html`: Raw HTML string
  
  ## Returns
  A map with counts of:
  - `:with_slash`: The number of void elements with self-closing slash
  - `:without_slash`: The number of void elements without self-closing slash
  - `:total`: Total number of void elements found
  """
  def analyze_void_elements(raw_html) do
    void_elems = void_elements()
    
    # Build patterns to match void elements with or without trailing slash
    results = Enum.reduce(void_elems, %{with_slash: 0, without_slash: 0}, fn elem, acc ->
      # Pattern for self-closing tags with slash: <tag ... />
      with_slash_pattern = ~r/<#{elem}[^>]*\/>/i
      with_slash_count = Enum.count(Regex.scan(with_slash_pattern, raw_html))
      
      # Pattern for tags without slash: <tag ...> (not followed by </tag>)
      without_slash_pattern = ~r/<#{elem}[^>\/]*>(?!.*<\/#{elem}>)/i
      without_slash_count = Enum.count(Regex.scan(without_slash_pattern, raw_html))
      
      Map.update(acc, :with_slash, with_slash_count, &(&1 + with_slash_count))
      |> Map.update(:without_slash, without_slash_count, &(&1 + without_slash_count))
    end)
    
    # Add total count
    Map.put(results, :total, results.with_slash + results.without_slash)
  end
end