defmodule Divsoup.Achievement.FormFanatic do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule
  
  # Required number of different input types
  @required_input_types 5

  @impl true
  def evaluate(html_tree, _) do
    # Find all forms
    forms = Floki.find(html_tree, "form")
    
    if forms == [] do
      ["Page does not contain any form elements"]
    else
      # Find all input elements within forms and count unique types
      input_types = 
        Enum.flat_map(forms, fn form ->
          Floki.find(form, "input")
          |> Enum.map(fn input ->
            {_, attrs, _} = input
            attrs_map = Enum.into(attrs, %{})
            Map.get(attrs_map, "type", "text")  # Default is "text" if type not specified
          end)
        end)
        |> Enum.uniq()
      
      # Add textarea and select as they are different input types too
      form_elements = 
        Enum.flat_map(forms, fn form ->
          textareas = Floki.find(form, "textarea") |> length
          selects = Floki.find(form, "select") |> length
          
          cond do
            textareas > 0 and selects > 0 -> ["textarea", "select"]
            textareas > 0 -> ["textarea"]
            selects > 0 -> ["select"]
            true -> []
          end
        end)
      
      # Count unique input types including textarea and select
      unique_input_types = input_types ++ form_elements |> Enum.uniq()
      input_type_count = length(unique_input_types)
      
      if input_type_count >= @required_input_types do
        # Achievement earned
        []
      else
        ["Form only has #{input_type_count} different input types (#{Enum.join(unique_input_types, ", ")}), needs at least #{@required_input_types}"]
      end
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Form Fanatic",
      group: "form_fanatic",
      description: "Page has a <code>&lt;form&gt;</code> containing <strong>#{@required_input_types}</strong> or more different input types"
    }
  end
end