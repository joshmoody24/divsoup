defmodule Divsoup.Achievement.SlotMachine do
  @moduledoc """
  Detects pages that use three `<slot>` elements consecutively inside a `<template>`.
  """

  alias Divsoup.Achievement
  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _raw_html_string) do
    found_three_in_a_row? =
      html_tree
      |> Floki.find("template slot + slot + slot")
      |> Enum.any?()

    if found_three_in_a_row? do
      []
    else
      ["Page does not use three <slot> elements in a row in a <template>"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Slot Machine",
      group: "slot_machine",
      description: "Page uses three <code>&lt;slot&gt;</code> elements in a row in a <code>&lt;template&gt;</code>"
    }
  end
end
