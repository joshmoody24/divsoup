defmodule Divsoup.Achievement.HyperlinkCollectorPlatinumTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.HyperlinkCollectorPlatinum

  test "earns achievement when page links to at least 50 different external domains" do
    # Generate 60 domains to ensure we have enough
    domains = 
      1..60
      |> Enum.map(fn i -> "domain#{i}.example.com" end)

    links = domains
      |> Enum.map(fn domain -> "      <li><a href=\"https://#{domain}\">#{domain}</a></li>" end)
      |> Enum.join("\n")

    html = """
    <html>
      <head>
        <title>Hyperlink Connoisseur</title>
      </head>
      <body>
        <h1>Many External Links</h1>
        <ul>
    #{links}
        </ul>
      </body>
    </html>
    """

    assert_achievement_earned(HyperlinkCollectorPlatinum, html)
  end

  test "doesn't earn achievement when page links to fewer than 50 different external domains" do
    # Generate 40 domains, which is not enough
    domains = 
      1..40
      |> Enum.map(fn i -> "domain#{i}.example.com" end)

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

    assert_achievement_not_earned(HyperlinkCollectorPlatinum, html)
  end
end