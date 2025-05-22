defmodule Divsoup.Achievement.FlashbangTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.Flashbang

  test "earns achievement with light background and no dark mode support" do
    html = """
    <html>
      <head>
        <title>Flashbang Test</title>
      </head>
      <body style="background-color: #ffffff; color: #000000;">
        <div>Light background with no dark mode support</div>
      </body>
    </html>
    """

    assert_achievement_earned(Flashbang, html)
  end

  test "earns achievement with light background in html element" do
    html = """
    <html style="background-color: white;">
      <head>
        <title>Flashbang Test HTML Element</title>
      </head>
      <body>
        <div>Light background in HTML tag with no dark mode support</div>
      </body>
    </html>
    """

    assert_achievement_earned(Flashbang, html)
  end

  test "earns achievement with light background in style tag" do
    html = """
    <html>
      <head>
        <title>Flashbang Test Style Tag</title>
        <style>
          body {
            background-color: #ffffff;
            color: #000000;
          }
        </style>
      </head>
      <body>
        <div>Light background in style tag with no dark mode support</div>
      </body>
    </html>
    """

    assert_achievement_earned(Flashbang, html)
  end

  test "doesn't earn achievement with dark background" do
    html = """
    <html>
      <head>
        <title>No Flashbang Dark Background</title>
        <style>
          body {
            background-color: #121212;
            color: #ffffff;
          }
        </style>
      </head>
      <body>
        <div>Dark background with no media query</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(Flashbang, html)
  end

  test "doesn't earn achievement with proper dark mode support" do
    html = """
    <html>
      <head>
        <title>No Flashbang With Dark Mode Support</title>
        <style>
          body {
            background-color: #ffffff;
            color: #000000;
          }
          
          @media (prefers-color-scheme: dark) {
            body {
              background-color: #121212;
              color: #ffffff;
            }
          }
        </style>
      </head>
      <body>
        <div>Proper dark mode support</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(Flashbang, html)
  end
end