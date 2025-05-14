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
end