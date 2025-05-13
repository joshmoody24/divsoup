defmodule Divsoup.Achievement.ScriptonitePlatinumTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.ScriptonitePlatinum

  test "earns achievement when page is plaintext with no HTML tags" do
    # Pure plaintext content
    html = "This is just plain text content.\nNo HTML tags at all.\nJust pure text."

    assert_achievement_earned(ScriptonitePlatinum, html)
  end

  test "earns achievement when page has Chrome-style plaintext rendering" do
    # This replicates how Chrome wraps plaintext in minimal HTML when viewed in the browser
    html = """
    <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
      </head>
      <body>
        <pre style="word-wrap: break-word; white-space: pre-wrap;">This is plain text content.
    It has been wrapped in minimal HTML by the browser.
    But it's still considered plaintext.</pre>
      </body>
    </html>
    """

    assert_achievement_earned(ScriptonitePlatinum, html)
  end

  test "doesn't earn achievement when page has regular HTML content" do
    html = """
    <html>
      <head>
        <title>Regular HTML</title>
      </head>
      <body>
        <h1>This is HTML</h1>
        <p>This page has actual HTML elements.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(ScriptonitePlatinum, html)
  end

  test "doesn't earn achievement when pre tag has children" do
    html = """
    <html>
      <head>
        <meta charset="utf-8">
      </head>
      <body>
        <pre>
          <code>function example() {
            console.log("This is code");
          }</code>
        </pre>
      </body>
    </html>
    """

    assert_achievement_not_earned(ScriptonitePlatinum, html)
  end

  test "doesn't earn achievement when head has non-meta elements" do
    html = """
    <html>
      <head>
        <meta charset="utf-8">
        <title>Not Plaintext</title>
      </head>
      <body>
        <pre>This is wrapped in pre but not plaintext.</pre>
      </body>
    </html>
    """

    assert_achievement_not_earned(ScriptonitePlatinum, html)
  end
end