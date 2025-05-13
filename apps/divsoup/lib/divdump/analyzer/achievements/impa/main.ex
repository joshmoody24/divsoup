defmodule Divsoup.Achievement.Impa do
  @moduledoc """
  Detects pages that use the Shadow DOM via either:
  • JavaScript’s `element.attachShadow(…)`  
  • The new declarative `<template shadowroot="open|closed">`
  """

  alias Divsoup.Achievement
  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_html_tree, raw_html_string) do
    regex =
      ~r/\.attachShadow\s*\(|<template\s+[^>]*shadowroot\s*=\s*["'](?:open|closed)["'][^>]*>/

    case Regex.match?(regex, raw_html_string) do
      true ->
        []

      false ->
        ["The page does not use the Shadow DOM"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Impa",
      group: "impa",
      description: "Page uses the Shadow DOM"
    }
  end
end
