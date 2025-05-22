defmodule Divsoup.Achievement.DictionaryEnthusiast do
  @moduledoc """
  Detects pages using definition semantics:
  • `<dfn>` elements  
  • `<dl>` lists with `<dt>` and `<dd>` terms
  """

  alias Divsoup.Achievement
  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, _raw_html_string) do
    has_dfn? =
      html_tree
      |> Floki.find("dfn")
      |> any?()

    has_definition_list? =
      Floki.find(html_tree, "dl dt") |> any?() and
        Floki.find(html_tree, "dl dd") |> any?()

    if has_dfn? or has_definition_list? do
      []
    else
      ["Page does not use definition elements (<dfn> or <dl> with <dt> and <dd>)"]
    end
  end

  defp any?([]), do: false
  defp any?(_), do: true

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Dictionary Enthusiast",
      group: "dictionary_enthusiast",
      description: "Page uses definition elements (<dfn> or <dl> with <dt> and <dd>)"
    }
  end
end
