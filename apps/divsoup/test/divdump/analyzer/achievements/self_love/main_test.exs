defmodule Divsoup.Achievement.SelfLoveTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.SelfLove

  test "earns achievement when page has an anchor with href=\"#\"" do
    html = """
    <html>
      <head>
        <title>Self Love Test</title>
      </head>
      <body>
        <nav>
          <a href="/">Home</a>
          <a href="/about">About</a>
          <a href="#">Click me</a>
          <a href="/contact">Contact</a>
        </nav>
        <div>
          <p>Some content</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(SelfLove, html)
  end

  test "earns achievement with multiple self-referencing links" do
    html = """
    <html>
      <head>
        <title>Self Love Test</title>
      </head>
      <body>
        <nav>
          <a href="#">Menu 1</a>
          <a href="#">Menu 2</a>
          <a href="#">Menu 3</a>
        </nav>
        <div>
          <p>Some content with <a href="#">another link</a></p>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(SelfLove, html)
  end

  test "doesn't earn achievement without self-referencing links" do
    html = """
    <html>
      <head>
        <title>Self Love Test</title>
      </head>
      <body>
        <nav>
          <a href="/">Home</a>
          <a href="/about">About</a>
          <a href="#section1">Section 1</a>
          <a href="/contact">Contact</a>
        </nav>
        <div>
          <p>Some content</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(SelfLove, html)
  end
end