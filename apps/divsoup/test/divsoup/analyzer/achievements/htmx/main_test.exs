defmodule Divsoup.Achievement.HtmxTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.Htmx

  test "earns achievement when page has htmx script reference" do
    html = """
    <html>
      <head>
        <title>HTMX Demo</title>
        <script src="https://unpkg.com/htmx.org@1.9.2"></script>
      </head>
      <body>
        <button hx-post="/clicked" hx-swap="outerHTML">
          Click Me
        </button>
      </body>
    </html>
    """

    assert_achievement_earned(Htmx, html)
  end

  test "earns achievement when page mentions htmx in content" do
    html = """
    <html>
      <head>
        <title>Web Tech Blog</title>
      </head>
      <body>
        <h1>Modern Web Technologies</h1>
        <p>Today we'll be exploring HTMX, a powerful library for creating dynamic interfaces.</p>
      </body>
    </html>
    """

    assert_achievement_earned(Htmx, html)
  end

  test "earns achievement when page has htmx attributes" do
    html = """
    <html>
      <head>
        <title>HTMX Demo</title>
      </head>
      <body>
        <div hx-get="/api/data" hx-trigger="load">
          Loading...
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(Htmx, html)
  end

  test "doesn't earn achievement when page doesn't mention htmx" do
    html = """
    <html>
      <head>
        <title>Regular Website</title>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
      </head>
      <body>
        <h1>Welcome</h1>
        <p>This is a website that doesn't use any fancy hypermedia technology.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(Htmx, html)
  end
end