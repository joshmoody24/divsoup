defmodule Divsoup.Achievement.BulletHellTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.BulletHell

  test "earns achievement when page uses unicode bullets in consecutive elements" do
    html = """
    <html>
      <head>
        <title>Bullet Points</title>
      </head>
      <body>
        <h1>A List Without UL</h1>
        <p>• First item in the list</p>
        <p>• Second item in the list</p>
        <p>• Third item in the list</p>
      </body>
    </html>
    """

    assert_achievement_earned(BulletHell, html)
  end

  test "earns achievement when page uses unicode bullets within a single element" do
    html = """
    <html>
      <head>
        <title>Bullet Points</title>
      </head>
      <body>
        <h1>A List Without UL</h1>
        <div>
          • First item in the list
          • Second item in the list
          • Third item in the list
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(BulletHell, html)
  end

  test "doesn't earn achievement when page uses proper <ul> elements" do
    html = """
    <html>
      <head>
        <title>Proper List</title>
      </head>
      <body>
        <h1>A Proper List</h1>
        <ul>
          <li>First item</li>
          <li>Second item</li>
          <li>Third item</li>
        </ul>
      </body>
    </html>
    """

    assert_achievement_not_earned(BulletHell, html)
  end

  test "doesn't earn achievement when page has no lists at all" do
    html = """
    <html>
      <head>
        <title>No Lists</title>
      </head>
      <body>
        <h1>A Page Without Lists</h1>
        <p>This page doesn't have any lists, bullet points, or anything resembling a list.</p>
        <p>Just some paragraphs of text.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(BulletHell, html)
  end
end