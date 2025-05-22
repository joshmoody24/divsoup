defmodule Divsoup.Achievement.PhDPurist do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html_tree, raw_html) do
    # Find math elements
    math_elements = Floki.find(html_tree, "math")
    
    if has_nontrivial_math?(math_elements, raw_html) do
      []
    else
      ["No nontrivial <math> element found"]
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: nil,
      title: "PhD Purist",
      group: "phd_purist",
      description: "Use the <code>&lt;math&gt;</code> element for something nontrivial"
    }
  end
  
  # Check if there's at least one nontrivial math element
  # We consider a math element nontrivial if:
  # 1. It contains specific MathML elements that suggest complex formulas, OR
  # 2. It has at least 5 child elements (simple expressions like "2+2" won't qualify)
  defp has_nontrivial_math?(math_elements, _raw_html) do
    math_elements
    |> Enum.any?(fn math_element ->
      children = Floki.children(math_element)
      child_count = length(children)
      
      # Check if there are at least 5 child elements (more than a simple expression)
      has_many_children = child_count >= 5
      
      # Check for specific MathML elements that suggest complexity
      has_complex_elements =
        Floki.find(math_element, "mfrac, msqrt, mroot, msubsup, munderover, mtable")
        |> Enum.any?()
        
      has_many_children or has_complex_elements
    end)
  end
end
