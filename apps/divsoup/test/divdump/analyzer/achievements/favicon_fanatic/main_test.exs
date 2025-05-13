defmodule Divsoup.Achievement.FaviconFanaticTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.FaviconFanatic

  test "earns achievement when head has more than 3 favicon links" do
    html = """
    <html>
      <head>
        <title>Favicon Test</title>
        <link rel="icon" href="/favicon.ico" sizes="32x32">
        <link rel="icon" href="/favicon-16x16.png" sizes="16x16">
        <link rel="icon" href="/favicon-32x32.png" sizes="32x32">
        <link rel="icon" href="/favicon-192x192.png" sizes="192x192">
        <link rel="stylesheet" href="/styles.css">
      </head>
      <body>
        <div>Content</div>
      </body>
    </html>
    """

    assert_achievement_earned(FaviconFanatic, html)
  end

  test "doesn't earn achievement when head has 3 or fewer favicon links" do
    html = """
    <html>
      <head>
        <title>Favicon Test</title>
        <link rel="icon" href="/favicon.ico">
        <link rel="icon" href="/favicon-16x16.png" sizes="16x16">
        <link rel="icon" href="/favicon-32x32.png" sizes="32x32">
        <link rel="stylesheet" href="/styles.css">
        <link rel="apple-touch-icon" href="/apple-touch-icon.png">
      </head>
      <body>
        <div>Content</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(FaviconFanatic, html)
  end
end