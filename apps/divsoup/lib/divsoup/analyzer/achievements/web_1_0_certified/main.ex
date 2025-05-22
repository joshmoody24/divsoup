defmodule Divsoup.Achievement.Web10Certified do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule

  @impl true
  def evaluate(_html_tree, raw_html) do
    # Check for HTML 3.2 DOCTYPE declaration
    # There are multiple valid formats:
    # - <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
    # - <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
    # Need to be tolerant of various whitespace and variations
    html32_doctype =
      ~r/<!DOCTYPE\s+HTML\s+PUBLIC\s+"-\/\/W3C\/\/DTD\s+HTML\s+3\.2(\s+Final)?\/\/EN"/i

    if Regex.match?(html32_doctype, raw_html) do
      # Achievement earned
      []
    else
      ["Page does not have an HTML 3.2 DOCTYPE declaration"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "Web 1.0 Certified",
      group: "the_good_old_days",
      description: "Page is authored in HTML 3.2"
    }
  end
end

