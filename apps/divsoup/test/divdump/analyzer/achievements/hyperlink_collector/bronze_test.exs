defmodule Divsoup.Achievement.HyperlinkCollectorBronzeTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.HyperlinkCollectorBronze

  test "earns achievement when page links to at least 5 different external domains" do
    html = """
    <html>
      <head>
        <title>Hyperlink Collector</title>
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
        </ul>
      </body>
    </html>
    """

    assert_achievement_earned(HyperlinkCollectorBronze, html)
  end

  test "doesn't earn achievement when page links to fewer than 5 different external domains" do
    html = """
    <html>
      <head>
        <title>Few External Links</title>
      </head>
      <body>
        <h1>External Links</h1>
        <ul>
          <li><a href="https://example.com">Example</a></li>
          <li><a href="https://google.com">Google</a></li>
          <li><a href="https://github.com">GitHub</a></li>
          <li><a href="https://example.com/page2">Example Page 2</a></li>
          <li><a href="/relative-path">Relative Link</a></li>
          <li><a href="#section">Section Link</a></li>
        </ul>
      </body>
    </html>
    """

    assert_achievement_not_earned(HyperlinkCollectorBronze, html)
  end

  test "handles edge cases correctly" do
    html = """
    <html>
      <head>
        <title>Edge Cases</title>
      </head>
      <body>
        <h1>Various Link Types</h1>
        <ul>
          <li><a href="https://example.com">Example</a></li>
          <li><a href="//google.com">Protocol-relative Google</a></li>
          <li><a href="javascript:void(0)">JavaScript Link</a></li>
          <li><a href="mailto:test@example.com">Email Link</a></li>
          <li><a href="tel:+1234567890">Phone Link</a></li>
          <li><a href="https://example.com?param=value">Example with Query</a></li>
          <li><a href="https://subdomain.github.com">GitHub Subdomain</a></li>
          <li><a href="https://github.com/user/repo">GitHub Repository</a></li>
          <li><a href="https://stackoverflow.com">Stack Overflow</a></li>
          <li><a href="https://wikipedia.org">Wikipedia</a></li>
        </ul>
      </body>
    </html>
    """

    # Should count 5 unique domains: example.com, google.com, github.com, stackoverflow.com, wikipedia.org
    assert_achievement_earned(HyperlinkCollectorBronze, html)
  end
end