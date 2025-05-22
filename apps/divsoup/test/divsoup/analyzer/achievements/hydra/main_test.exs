defmodule Divsoup.Achievement.HydraTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.Hydra

  test "earns achievement when page has multiple h1 elements" do
    html = """
    <html>
      <head>
        <title>Hydra Test</title>
      </head>
      <body>
        <h1>First Heading</h1>
        <p>Some content here</p>
        <h1>Second Heading</h1>
        <p>More content here</p>
        <div>
          <h1>Third Heading</h1>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(Hydra, html)
  end

  test "doesn't earn achievement with only one h1 element" do
    html = """
    <html>
      <head>
        <title>Hydra Test</title>
      </head>
      <body>
        <h1>Main Heading</h1>
        <p>Some content here</p>
        <h2>Subheading</h2>
        <p>More content here</p>
        <h3>Another subheading</h3>
      </body>
    </html>
    """

    assert_achievement_not_earned(Hydra, html)
  end

  test "doesn't earn achievement with no h1 elements" do
    html = """
    <html>
      <head>
        <title>Hydra Test</title>
      </head>
      <body>
        <h2>Subheading</h2>
        <p>Some content here</p>
        <h3>Another subheading</h3>
        <p>More content here</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(Hydra, html)
  end
end