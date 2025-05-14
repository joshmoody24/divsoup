defmodule Divsoup.Achievement.HyperlinkCollectorSilverTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.HyperlinkCollectorSilver

  test "earns achievement when page links to at least 10 different external domains" do
    html = """
    <html>
      <head>
        <title>Hyperlink Custodian</title>
      </head>
      <body>
        <h1>External Links</h1>
        <ul>
          <li><a href="https://example.com">Example</a></li>
          <li><a href="https://google.com">Google</a></li>
          <li><a href="https://github.com">GitHub</a></li>
          <li><a href="https://stackoverflow.com">Stack Overflow</a></li>
          <li><a href="https://wikipedia.org">Wikipedia</a></li>
          <li><a href="https://mozilla.org">Mozilla</a></li>
          <li><a href="https://microsoft.com">Microsoft</a></li>
          <li><a href="https://apple.com">Apple</a></li>
          <li><a href="https://amazon.com">Amazon</a></li>
          <li><a href="https://netflix.com">Netflix</a></li>
          <li><a href="https://facebook.com">Facebook</a></li>
        </ul>
      </body>
    </html>
    """

    assert_achievement_earned(HyperlinkCollectorSilver, html)
  end

  test "doesn't earn achievement when page links to fewer than 10 different external domains" do
    html = """
    <html>
      <head>
        <title>Not Enough External Links</title>
      </head>
      <body>
        <h1>External Links</h1>
        <ul>
          <li><a href="https://example.com">Example</a></li>
          <li><a href="https://google.com">Google</a></li>
          <li><a href="https://github.com">GitHub</a></li>
          <li><a href="https://stackoverflow.com">Stack Overflow</a></li>
          <li><a href="https://wikipedia.org">Wikipedia</a></li>
          <li><a href="https://mozilla.org">Mozilla</a></li>
          <li><a href="https://microsoft.com">Microsoft</a></li>
          <li><a href="https://apple.com">Apple</a></li>
          <li><a href="https://example.com/page2">Example Page 2</a></li>
        </ul>
      </body>
    </html>
    """

    assert_achievement_not_earned(HyperlinkCollectorSilver, html)
  end
end