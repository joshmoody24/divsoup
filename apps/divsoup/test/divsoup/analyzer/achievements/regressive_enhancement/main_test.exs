defmodule Divsoup.Achievement.RegressiveEnhancementTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.RegressiveEnhancement

  test "earns achievement when page has a noscript tag with minimal content" do
    html = """
    <html>
      <head>
        <title>Minimal NoScript</title>
      </head>
      <body>
        <script>
          document.write('This is a fancy page with JavaScript!');
        </script>
        <noscript>No JS :(</noscript>
        <p>Main content of the page.</p>
      </body>
    </html>
    """

    assert_achievement_earned(RegressiveEnhancement, html)
  end

  test "earns achievement when page has an empty noscript tag" do
    html = """
    <html>
      <head>
        <title>Empty NoScript</title>
      </head>
      <body>
        <script>
          document.write('This is a fancy page with JavaScript!');
        </script>
        <noscript></noscript>
        <p>Main content of the page.</p>
      </body>
    </html>
    """

    assert_achievement_earned(RegressiveEnhancement, html)
  end

  test "doesn't earn achievement when noscript has substantial content" do
    html = """
    <html>
      <head>
        <title>Substantial NoScript</title>
      </head>
      <body>
        <script>
          document.write('This is a fancy page with JavaScript!');
        </script>
        <noscript>
          <h2>JavaScript is Required</h2>
          <p>This website requires JavaScript to function properly. Please enable JavaScript in your browser settings to continue.</p>
          <p>If you cannot enable JavaScript, you can visit our text-only version of the site at <a href="text-version.html">this link</a>.</p>
        </noscript>
        <p>Main content of the page.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(RegressiveEnhancement, html)
  end

  test "doesn't earn achievement when page has no noscript tags" do
    html = """
    <html>
      <head>
        <title>No NoScript</title>
      </head>
      <body>
        <script>
          document.write('This is a fancy page with JavaScript!');
        </script>
        <p>Main content of the page.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(RegressiveEnhancement, html)
  end
end