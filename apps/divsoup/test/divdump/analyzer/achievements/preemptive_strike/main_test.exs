defmodule Divsoup.Achievement.PreemptiveStrikeTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.PreemptiveStrike

  test "earns achievement with preload link" do
    html = """
    <html>
      <head>
        <title>Preload Test</title>
        <link rel="preload" href="style.css" as="style">
        <link rel="stylesheet" href="style.css">
      </head>
      <body>
        <div>
          <p>This page preloads its stylesheet</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(PreemptiveStrike, html)
  end

  test "earns achievement with dns-prefetch link" do
    html = """
    <html>
      <head>
        <title>DNS Prefetch Test</title>
        <link rel="dns-prefetch" href="https://fonts.googleapis.com">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto">
      </head>
      <body>
        <div>
          <p>This page prefetches DNS for Google Fonts</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(PreemptiveStrike, html)
  end

  test "earns achievement with preconnect link" do
    html = """
    <html>
      <head>
        <title>Preconnect Test</title>
        <link rel="preconnect" href="https://example.com">
        <script src="https://example.com/script.js"></script>
      </head>
      <body>
        <div>
          <p>This page preconnects to example.com</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(PreemptiveStrike, html)
  end

  test "earns achievement with multiple preemptive links" do
    html = """
    <html>
      <head>
        <title>Multiple Preemptive Links</title>
        <link rel="preload" href="critical.css" as="style">
        <link rel="dns-prefetch" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://api.example.com">
      </head>
      <body>
        <div>
          <p>This page uses multiple preemptive techniques</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(PreemptiveStrike, html)
  end

  test "doesn't earn achievement without preemptive links" do
    html = """
    <html>
      <head>
        <title>No Preemptive Links</title>
        <link rel="stylesheet" href="style.css">
        <link rel="icon" href="favicon.ico">
      </head>
      <body>
        <div>
          <p>This page doesn't use any preemptive loading techniques</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(PreemptiveStrike, html)
  end
end