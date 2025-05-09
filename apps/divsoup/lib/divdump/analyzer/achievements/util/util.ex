defmodule Divsoup.Util.DivSoup do
  def get_div_ratio(html_tree) do
    div_count = Floki.find(html_tree, "div") |> length()
    element_count = Floki.find(html_tree, "*") |> length()
    div_count / element_count
  end
end
