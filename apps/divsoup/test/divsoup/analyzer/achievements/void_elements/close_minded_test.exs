defmodule Divsoup.Achievement.VoidElements.CloseMindedTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.VoidElements.CloseMinded
  alias Divsoup.Util.Html

  test "earns achievement when all void elements have trailing slash" do
    # Create an HTML document with various void elements, all with trailing slash
    void_elements = Html.void_elements()
    
    # Create self-closing tags with trailing slash
    element_tags = Enum.map(void_elements, fn elem ->
      case elem do
        # Special cases that need attributes to be valid
        "img" -> "<img src=\"image.jpg\" alt=\"test\" />"
        "input" -> "<input type=\"text\" />"
        "embed" -> "<embed src=\"file.swf\" />"
        "source" -> "<source src=\"video.mp4\" type=\"video/mp4\" />"
        "track" -> "<track src=\"subtitles.vtt\" />"
        "area" -> "<area shape=\"rect\" coords=\"0,0,0,0\" href=\"#\" />"
        "base" -> "<base href=\"/\" />"
        "link" -> "<link rel=\"stylesheet\" href=\"style.css\" />"
        "meta" -> "<meta charset=\"utf-8\" />"
        # Default case
        _ -> "<#{elem} />"
      end
    end)
    
    html = """
    <html>
      <head>
        <title>Close-minded Test</title>
        #{Enum.join(Enum.filter(element_tags, fn tag -> 
          String.starts_with?(tag, "<meta") || 
          String.starts_with?(tag, "<base") || 
          String.starts_with?(tag, "<link")
        end), "\n        ")}
      </head>
      <body>
        <div>
          #{Enum.join(Enum.filter(element_tags, fn tag -> 
            !String.starts_with?(tag, "<meta") && 
            !String.starts_with?(tag, "<base") && 
            !String.starts_with?(tag, "<link")
          end), "\n          ")}
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(CloseMinded, html)
  end

  test "doesn't earn achievement when some void elements don't have trailing slash" do
    html = """
    <html>
      <head>
        <title>Mixed Void Elements</title>
        <meta charset="utf-8">
        <link rel="stylesheet" href="style.css" />
      </head>
      <body>
        <div>
          <img src="image.jpg" alt="test" />
          <br>
          <hr />
          <input type="text">
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(CloseMinded, html)
  end

  test "doesn't earn achievement when no void elements are present" do
    html = """
    <html>
      <head>
        <title>No Void Elements</title>
      </head>
      <body>
        <div>
          <p>This page has no void elements.</p>
          <span>Just regular elements with content.</span>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(CloseMinded, html)
  end
end