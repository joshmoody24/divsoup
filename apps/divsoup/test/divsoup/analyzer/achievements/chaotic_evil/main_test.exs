defmodule Divsoup.Achievement.ChaoticEvilTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.ChaoticEvil

  test "earns achievement with light background in dark mode" do
    html = """
    <html>
      <head>
        <title>Chaotic Evil Test</title>
        <style>
          body {
            background-color: #f0f0f0;
            color: #000000;
          }
          
          @media (prefers-color-scheme: dark) {
            body {
              background-color: #ffffff;
              color: #000000;
            }
          }
        </style>
      </head>
      <body>
        <div>Light background in dark mode</div>
      </body>
    </html>
    """

    assert_achievement_earned(ChaoticEvil, html)
  end

  test "earns achievement with dark background in light mode" do
    html = """
    <html>
      <head>
        <title>Chaotic Evil Test Reverse</title>
        <style>
          body {
            background-color: #f0f0f0;
            color: #000000;
          }
          
          @media (prefers-color-scheme: light) {
            body {
              background-color: #000000;
              color: #ffffff;
            }
          }
        </style>
      </head>
      <body>
        <div>Dark background in light mode</div>
      </body>
    </html>
    """

    assert_achievement_earned(ChaoticEvil, html)
  end

  test "earns achievement with fully reversed colors" do
    html = """
    <html>
      <head>
        <title>Full Chaotic Evil Test</title>
        <style>
          body {
            background-color: #f0f0f0;
            color: #000000;
          }
          
          @media (prefers-color-scheme: dark) {
            body {
              background-color: #ffffff;
              color: #000000;
            }
          }
          
          @media (prefers-color-scheme: light) {
            body {
              background-color: #000000;
              color: #ffffff;
            }
          }
        </style>
      </head>
      <body>
        <div>Completely reversed color schemes</div>
      </body>
    </html>
    """

    assert_achievement_earned(ChaoticEvil, html)
  end

  test "doesn't earn achievement with proper color scheme support" do
    html = """
    <html>
      <head>
        <title>No Chaotic Evil - Proper Support</title>
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
        <div>Proper color scheme support</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(ChaoticEvil, html)
  end

  test "doesn't earn achievement without color scheme media queries" do
    html = """
    <html>
      <head>
        <title>No Chaotic Evil - No Media Queries</title>
        <style>
          body {
            background-color: #ffffff;
            color: #000000;
          }
        </style>
      </head>
      <body>
        <div>No media queries for color schemes</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(ChaoticEvil, html)
  end
end