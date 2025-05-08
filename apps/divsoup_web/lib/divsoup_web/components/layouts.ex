defmodule DivsoupWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use DivsoupWeb, :controller` and
  `use DivsoupWeb, :live_view`.
  """
  use DivsoupWeb, :html
  alias Divsoup.Analyzer.JobQueue

  embed_templates "layouts/*"
  
  @doc """
  Renders a terminal-style prompt with no space between tags.
  
  ## Attributes

    * `heading` - The text to display in the terminal prompt
  """
  attr :heading, :string, default: "divsoup"
  
  def terminal_prompt(assigns) do
    ~H"""
    <h1 class="logo terminal-prompt"><!--
    --><a href="#" class="no-style"><%= @heading %></a><!--
    --></h1>
    """
  end
end
