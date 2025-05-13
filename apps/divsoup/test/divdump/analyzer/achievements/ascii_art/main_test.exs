defmodule Divsoup.Achievement.AsciiArtTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.AsciiArt

  test "earns achievement with ASCII art in HTML comment" do
    html = """
    <html>
      <head>
        <title>ASCII Art Test</title>
      </head>
      <body>
        <h1>ASCII Art Example</h1>
        <!-- 
          +---------+
          |  ASCII  |
          |   Art   |
          |  Rules! |
          +---------+
        -->
        <p>Some visible content</p>
      </body>
    </html>
    """

    assert_achievement_earned(AsciiArt, html)
  end

  test "earns achievement with more complex ASCII art" do
    html = """
    <html>
      <head>
        <title>ASCII Art Test</title>
      </head>
      <body>
        <h1>ASCII Art Example</h1>
        <!-- 
             /\\_/\\
            ( o.o )
             > ^ <
        -->
        <p>Some visible content</p>
      </body>
    </html>
    """

    assert_achievement_earned(AsciiArt, html)
  end

  test "earns achievement with another ASCII art example" do
    html = """
    <html>
      <head>
        <title>ASCII Art Test</title>
      </head>
      <body>
        <!-- 
            _______
           /       \\
          |         |
          |_________|
              | |
              | |
              | |
        -->
        <p>Some content</p>
      </body>
    </html>
    """

    assert_achievement_earned(AsciiArt, html)
  end

  test "doesn't earn achievement with regular comments" do
    html = """
    <html>
      <head>
        <title>ASCII Art Test</title>
        <!-- This is a regular comment -->
      </head>
      <body>
        <h1>ASCII Art Example</h1>
        <!-- 
          This is a multi-line comment
          but it doesn't contain any ASCII art
          just regular text
        -->
        <p>Some visible content</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(AsciiArt, html)
  end
end