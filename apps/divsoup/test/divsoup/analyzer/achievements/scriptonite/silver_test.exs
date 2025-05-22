defmodule Divsoup.Achievement.ScriptoniteSilverTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.ScriptoniteSilver

  test "earns achievement when page has no script tags or on* attributes" do
    html = """
    <html>
      <head>
        <title>No JavaScript</title>
        <style>
          body { font-family: Arial, sans-serif; }
        </style>
      </head>
      <body>
        <h1>Static Page</h1>
        <p>This page doesn't use any JavaScript.</p>
        <a href="other-page.html">Go to another page</a>
      </body>
    </html>
    """

    assert_achievement_earned(ScriptoniteSilver, html)
  end

  test "doesn't earn achievement when page has script tags" do
    html = """
    <html>
      <head>
        <title>With JavaScript</title>
        <script src="app.js"></script>
      </head>
      <body>
        <h1>Dynamic Page</h1>
        <p>This page uses JavaScript.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(ScriptoniteSilver, html)
  end

  test "doesn't earn achievement when page has on* attributes" do
    html = """
    <html>
      <head>
        <title>Inline JavaScript</title>
      </head>
      <body>
        <h1>Event Handlers</h1>
        <button onclick="alert('Clicked!')">Click me</button>
        <div onmouseover="highlight(this)">Hover over me</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(ScriptoniteSilver, html)
  end
end