defmodule Divsoup.AchievementRule do
  alias Divsoup.Achievement

  @type hierarchy :: Achievement.hierarchy()

  @callback evaluate(Floki.html_tree()) :: boolean()
  @callback achievement() :: Achievement.t()
end
