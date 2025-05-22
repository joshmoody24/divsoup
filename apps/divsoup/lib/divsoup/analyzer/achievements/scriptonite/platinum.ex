defmodule Divsoup.Achievement.ScriptonitePlatinum do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(html, raw_html_string) do
    has_any_tags? =
      String.contains?(raw_html_string, "<") and String.contains?(raw_html_string, ">")

    # If there's no HTML-looking content at all, it's clearly plaintext
    if not has_any_tags? do
      []
    else
      # Check for the exact structure: <html><head><meta...></head><body><pre>...</pre></body></html>
      # (added by chrome when viewing txt files)
      case html do
        [{"html", _, html_children}] ->
          case html_children do
            [
              {"head", _, head_children},
              {"body", _, [{"pre", pre_attrs, [pre_text]}]}
            ]
            when is_binary(pre_text) ->
              # Ensure <head> only contains <meta> tags
              head_ok? =
                Enum.all?(head_children, fn
                  {"meta", _, _} -> true
                  _ -> false
                end)

              # Allow only "style" attribute (automatically added by Chrome)
              pre_attrs_ok? =
                Enum.all?(pre_attrs, fn {attr, _} -> attr in ["style"] end)

              if head_ok? and pre_attrs_ok? do
                # All checks passed — this is plaintext
                []
              else
                ["Page structure is close, but <head> or <pre> contains unexpected content"]
              end

            _ ->
              ["Page contains HTML elements beyond a single <pre> tag in <body>"]
          end

        _ ->
          ["Page is not wrapped in a single <html> element"]
      end
    end
  end

  @impl true
  def achievement() do
    %Achievement{
      hierarchy: :platinum,
      title: "Always bet on text",
      group: "the_web_is_for_documents",
      description: "Page is entirely plaintext - no CSS, JavaScript, or HTML elements"
    }
  end
end
