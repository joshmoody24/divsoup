defmodule Divsoup.Achievement.BlindPersonHater do
  @moduledoc """
  Detects pages with poor accessibility: 
  • Majority of images lack non‐empty `alt` attributes  
  • No ARIA attributes appear anywhere on the page
  """

  alias Divsoup.Achievement
  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _raw_html_string) do
    imgs = Floki.find(html_tree, "img")
    total_imgs = length(imgs)

    missing_alt_count =
      imgs
      |> Enum.filter(fn {_tag, attrs_list, _children} ->
        attrs = Map.new(attrs_list)
        not Map.has_key?(attrs, "alt") or attrs["alt"] == ""
      end)
      |> length()

    aria_present =
      html_tree
      |> Floki.find("*")
      |> Enum.any?(fn {_tag, attrs_list, _children} ->
        attrs_list
        |> Enum.any?(fn {name, _val} -> String.starts_with?(name, "aria-") end)
      end)

    missing_alt? = total_imgs > 0 and missing_alt_count > total_imgs / 2
    no_aria? = not aria_present

    case {missing_alt?, no_aria?} do
      {true, true} ->
        []

      {true, false} ->
        ["Majority of images lack alt tags"]

      {false, true} ->
        ["No ARIA attributes appear on the page"]

      {false, false} ->
        ["Majority of images have alt tags", "ARIA attributes appear on the page"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Blind Person Hater",
      group: "blind_person_hater",
      description: "Majority of images lack <code>alt</code> attributes and/or no ARIA attributes appear on the page"
    }
  end
end
