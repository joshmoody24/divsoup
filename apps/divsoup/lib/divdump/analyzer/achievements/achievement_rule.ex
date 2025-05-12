defmodule Divsoup.AchievementRule do
  alias Divsoup.Achievement

  @type hierarchy :: Achievement.hierarchy()

  @doc """
  Evaluates the HTML tree and returns a list of strings representing the reasons the achievement was not met.
  If the achievement is met, an empty list is returned.

  ## Parameters
  - `html_tree`: The HTML tree to evaluate.
  - `raw_html_string`: The raw HTML string to evaluate.
  """
  @callback evaluate(Floki.html_tree(), String.t()) :: [String.t()]
  @callback achievement() :: Achievement.t()
end
