defmodule Divsoup.Util.Classy do
  @doc """
      Calculates the size in chars of the class attribute of all elements in the HTML tree,
      and returns the ratio of that number to the total number of elements in the tree.
  """
  def get_class_ratio(html_tree, raw_html_string) do
    classes_size =
      Floki.find(html_tree, "*[class]")
      |> Enum.map(&Floki.attribute(&1, "class"))
      |> Enum.join(" ")
      |> String.length()

    document_size = raw_html_string |> String.length()

    if classes_size == 0 or document_size == 0 do
      0
    else
      (classes_size / document_size) |> Float.round(2)
    end
  end
end
