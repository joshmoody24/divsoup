defmodule Divsoup.Achievement.HyperlinkCollectorGoldTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.HyperlinkCollectorGold

  test "earns achievement when page links to at least 25 different external domains" do
    domains = [
      "example.com", "google.com", "github.com", "stackoverflow.com", "wikipedia.org",
      "mozilla.org", "microsoft.com", "apple.com", "amazon.com", "netflix.com",
      "facebook.com", "twitter.com", "instagram.com", "linkedin.com", "reddit.com",
      "medium.com", "spotify.com", "youtube.com", "twitch.tv", "github.io",
      "gitlab.com", "bitbucket.org", "dropbox.com", "slack.com", "discord.com",
      "zoom.us", "adobe.com", "salesforce.com", "wordpress.com", "shopify.com"
    ]

    links = domains
      |> Enum.map(fn domain -> "      <li><a href=\"https://#{domain}\">#{domain}</a></li>" end)
      |> Enum.join("\n")

    html = """
    <html>
      <head>
        <title>Hyperlink Curator</title>
      </head>
      <body>
        <h1>Many External Links</h1>
        <ul>
    #{links}
        </ul>
      </body>
    </html>
    """

    assert_achievement_earned(HyperlinkCollectorGold, html)
  end

  test "doesn't earn achievement when page links to fewer than 25 different external domains" do
    domains = [
      "example.com", "google.com", "github.com", "stackoverflow.com", "wikipedia.org",
      "mozilla.org", "microsoft.com", "apple.com", "amazon.com", "netflix.com",
      "facebook.com", "twitter.com", "instagram.com", "linkedin.com", "reddit.com",
      "medium.com", "spotify.com", "youtube.com", "twitch.tv", "github.io"
    ]

    links = domains
      |> Enum.map(fn domain -> "      <li><a href=\"https://#{domain}\">#{domain}</a></li>" end)
      |> Enum.join("\n")

    html = """
    <html>
      <head>
        <title>Not Enough External Links</title>
      </head>
      <body>
        <h1>Some External Links</h1>
        <ul>
    #{links}
        </ul>
      </body>
    </html>
    """

    assert_achievement_not_earned(HyperlinkCollectorGold, html)
  end
end