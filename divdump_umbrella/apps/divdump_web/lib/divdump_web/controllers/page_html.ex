defmodule DivdumpWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use DivdumpWeb, :html
  alias Divdump.Analyzer.Job

  embed_templates "page_html/*"
end
