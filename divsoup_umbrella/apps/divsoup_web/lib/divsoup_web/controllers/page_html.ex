defmodule DivsoupWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use DivsoupWeb, :html
  alias Divsoup.Analyzer.Job

  embed_templates "page_html/*"
end
