defmodule Divsoup.Achievement.ScriptoniteGoldTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.ScriptoniteGold

  test "earns achievement when page has no JavaScript, CSS, or images" do
    html = """
    <html>
      <head>
        <title>Pure HTML</title>
      </head>
      <body>
        <h1>Text-Only Page</h1>
        <p>This page contains only pure HTML with no JavaScript, CSS, or images.</p>
        <ul>
          <li>Item 1</li>
          <li>Item 2</li>
          <li>Item 3</li>
        </ul>
      </body>
    </html>
    """

    assert_achievement_earned(ScriptoniteGold, html)
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

    assert_achievement_not_earned(ScriptoniteGold, html)
  end

  test "doesn't earn achievement when page has event attributes" do
    html = """
    <html>
      <head>
        <title>With Event Handlers</title>
      </head>
      <body>
        <h1>Interactive Elements</h1>
        <button onclick="doSomething()">Click me</button>
      </body>
    </html>
    """

    assert_achievement_not_earned(ScriptoniteGold, html)
  end

  test "doesn't earn achievement when page has inline CSS" do
    html = """
    <html>
      <head>
        <title>With Inline Styles</title>
      </head>
      <body>
        <h1 style="color: red; font-size: 24px;">Styled Heading</h1>
        <p>Some text content.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(ScriptoniteGold, html)
  end

  test "doesn't earn achievement when page has style tags" do
    html = """
    <html>
      <head>
        <title>With Style Tags</title>
        <style>
          body { font-family: Arial, sans-serif; }
          h1 { color: blue; }
        </style>
      </head>
      <body>
        <h1>Styled Page</h1>
        <p>Text with embedded CSS.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(ScriptoniteGold, html)
  end

  test "doesn't earn achievement when page has external CSS" do
    html = """
    <html>
      <head>
        <title>With External CSS</title>
        <link rel="stylesheet" href="styles.css">
      </head>
      <body>
        <h1>Styled Page</h1>
        <p>Text with external CSS.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(ScriptoniteGold, html)
  end

  test "doesn't earn achievement when page has images" do
    html = """
    <html>
      <head>
        <title>With Images</title>
      </head>
      <body>
        <h1>Visual Content</h1>
        <img src="example.jpg" alt="Example image">
        <p>Page with images.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(ScriptoniteGold, html)
  end
end