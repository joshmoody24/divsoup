defmodule Divsoup.Achievement.VoidElements.DoubleMindedTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.VoidElements.DoubleMinded

  test "earns achievement when some void elements have trailing slash and some don't" do
    html = """
    <html>
      <head>
        <title>Double-minded Test</title>
        <meta charset="utf-8">
        <link rel="stylesheet" href="style.css" />
        <base href="/">
      </head>
      <body>
        <div>
          <img src="image.jpg" alt="test" />
          <br>
          <hr />
          <input type="text">
          <source src="video.mp4" type="video/mp4">
          <wbr />
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(DoubleMinded, html)
  end

  test "doesn't earn achievement when all void elements have trailing slash" do
    html = """
    <html>
      <head>
        <title>All Slashed Elements</title>
        <meta charset="utf-8" />
        <link rel="stylesheet" href="style.css" />
      </head>
      <body>
        <div>
          <img src="image.jpg" alt="test" />
          <br />
          <hr />
          <input type="text" />
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(DoubleMinded, html)
  end

  test "doesn't earn achievement when all void elements omit trailing slash" do
    html = """
    <html>
      <head>
        <title>All Unslashed Elements</title>
        <meta charset="utf-8">
        <link rel="stylesheet" href="style.css">
      </head>
      <body>
        <div>
          <img src="image.jpg" alt="test">
          <br>
          <hr>
          <input type="text">
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(DoubleMinded, html)
  end

  test "doesn't earn achievement with only one void element" do
    html = """
    <html>
      <head>
        <title>Just One Void Element</title>
      </head>
      <body>
        <div>
          <p>This page has only one void element.</p>
          <br>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(DoubleMinded, html)
  end

  test "doesn't earn achievement when no void elements are present" do
    html = """
    <html>
      <head>
        <title>No Void Elements</title>
      </head>
      <body>
        <div>
          <p>This page has no void elements.</p>
          <span>Just regular elements with content.</span>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(DoubleMinded, html)
  end
end