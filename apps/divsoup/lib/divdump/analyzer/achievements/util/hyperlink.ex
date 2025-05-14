defmodule Divsoup.Util.Hyperlink do
  @moduledoc """
  Utility functions for analyzing hyperlinks in HTML content.
  """

  @doc """
  Count unique external domains in hyperlinks.

  Returns the number of unique external domains found in the a href attributes.

  ## Parameters
  - html_tree: Floki HTML tree
  """
  @spec count_unique_external_domains(Floki.html_tree()) :: integer()
  def count_unique_external_domains(html_tree) do
    html_tree
    |> Floki.find("a[href]")
    |> Enum.map(fn element ->
      Floki.attribute(element, "href") |> List.first()
    end)
    |> Enum.filter(&is_external_link?/1)
    |> Enum.map(&extract_domain/1)
    |> Enum.filter(&(&1 != nil))
    |> Enum.uniq()
    |> length()
  end

  @doc """
  Check if a link is external (not relative or same-domain).

  ## Parameters
  - url: URL string to check
  """
  @spec is_external_link?(String.t()) :: boolean()
  def is_external_link?(url) do
    cond do
      # Skip javascript, mailto, tel links
      String.starts_with?(url, ["javascript:", "mailto:", "tel:", "#"]) ->
        false

      # Skip relative paths
      !String.contains?(url, "://") && !String.starts_with?(url, "//") ->
        false

      # Include only http/https links
      String.starts_with?(url, ["http://", "https://", "//"]) ->
        true

      # Everything else is not external
      true ->
        false
    end
  end

  @doc """
  Extract domain from a URL.

  Returns the domain name without protocol, path, or query string.

  ## Parameters
  - url: URL string
  """
  @spec extract_domain(String.t()) :: String.t() | nil
  def extract_domain(url) do
    url = if String.starts_with?(url, "//"), do: "https:" <> url, else: url

    case URI.parse(url) do
      %URI{host: nil} -> nil
      %URI{host: host} -> host
    end
  end
end

