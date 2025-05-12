defmodule Divsoup.AchievementList do
  @app :divsoup

  @doc "Returns a list of all modules that implement the Divsoup.AchievementRule behavior."
  def all do
    {:ok, modules} = :application.get_key(@app, :modules)

    modules
    |> Enum.filter(&is_atom/1)
    |> Enum.filter(&is_achievement_rule_module?/1)
  end

  defp is_achievement_rule_module?(module) do
    try do
      # First check if it's loaded and has the right name pattern
      # Then check if it implements the required callbacks
      is_loaded = Code.ensure_loaded?(module)
      has_pattern = module_name_matches_pattern?(module)
      has_evaluate = function_exported?(module, :evaluate, 2)
      has_achievement = function_exported?(module, :achievement, 0)

      is_loaded and has_pattern and has_evaluate and has_achievement
    rescue
      error ->
        IO.puts("Error checking module #{inspect(module)}: #{inspect(error)}")
        false
    end
  end

  # Check if module name follows the pattern for achievement rules
  defp module_name_matches_pattern?(module) do
    module_string = Atom.to_string(module)

    result =
      String.starts_with?(module_string, "Elixir.Divsoup.Achievement") and
        not String.ends_with?(module_string, "List")

    result
  end
end
