defmodule Divsoup.Util.WebFramework do
  @moduledoc """
  Detect which of several popular front-end frameworks appears to be in use
  by inspecting attributes, tags or script URLs in the HTML DOM.
  """

  @doc """
  Given a Floki-parsed HTML tree, returns a list of framework names
  detected in the DOM.
  """
  @spec detected_web_frameworks(Floki.html_tree()) :: [String.t()]
  def detected_web_frameworks(html_tree) do
    [
      {"React", &react?/1},
      {"Angular", &angular?/1},
      {"Vue", &vue?/1},
      {"Ember", &ember?/1},
      {"Svelte", &svelte?/1},
      {"Polymer", &polymer?/1}
    ]
    |> Enum.filter(fn {_name, detector} -> detector.(html_tree) end)
    |> Enum.map(fn {name, _detector} -> name end)
  end

  # — Private detectors —  

  defp react?(tree) do
    tree
    |> Floki.find("[data-reactroot], [data-reactid], script[src*='react']")
    |> any?()
  end

  defp angular?(tree) do
    tree
    |> Floki.find("[ng-app], [ng-controller], [ng-version], script[src*='angular']")
    |> any?()
  end

  defp vue?(tree) do
    tree
    |> Floki.find("[v-bind], [v-model], [v-for], [v-if], [data-v-]")
    |> any?()
  end

  defp ember?(tree) do
    tree
    |> Floki.find("[data-ember-view], .ember-application, script[src*='ember']")
    |> any?()
  end

  defp svelte?(tree) do
    tree
    |> Floki.find("[data-svelte-component], [data-svelte-hydrate], script[src*='svelte']")
    |> any?()
  end

  defp polymer?(tree) do
    tree
    |> Floki.find("dom-module, script[src*='polymer']")
    |> any?()
  end

  defp any?([]), do: false
  defp any?(_), do: true
end
