defmodule DivsoupWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use DivsoupWeb, :html
  alias Divsoup.Analyzer.Job

  embed_templates "page_html/*"
  
  # Helper functions for the achievements page
  def format_group_name(group) do
    group
    |> String.replace("_", " ")
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
  
  def achievement_class(hierarchy) do
    case hierarchy do
      :bronze -> "bronze"
      :silver -> "silver"
      :gold -> "gold"
      :platinum -> "platinum"
      _ -> "standard"
    end
  end
  
  # Helper to get hyphenless job ID for URLs
  def hyphenless_job_id(job) do
    Job.hyphenless_id(job)
  end
end
