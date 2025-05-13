defmodule Divsoup.Achievement.CommentatorInChiefTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.CommentatorInChief

  test "earns achievement when page has more than 10 HTML comments" do
    html = """
    <html>
      <head>
        <title>Commentator Test</title>
        <!-- Comment 1 -->
        <!-- Comment 2 -->
        <!-- Comment 3 -->
        <!-- Comment 4 -->
        <!-- Comment 5 -->
      </head>
      <body>
        <!-- Comment 6 -->
        <div>Some content</div>
        <!-- Comment 7 -->
        <p>Some paragraph</p>
        <!-- Comment 8 -->
        <!-- Comment 9 -->
        <span>Some span</span>
        <!-- Comment 10 -->
        <!-- Comment 11 -->
      </body>
    </html>
    """

    assert_achievement_earned(CommentatorInChief, html)
  end

  test "doesn't earn achievement when page has 10 or fewer HTML comments" do
    html = """
    <html>
      <head>
        <title>Commentator Test</title>
        <!-- Comment 1 -->
        <!-- Comment 2 -->
        <!-- Comment 3 -->
      </head>
      <body>
        <!-- Comment 4 -->
        <div>Some content</div>
        <!-- Comment 5 -->
        <p>Some paragraph</p>
        <!-- Comment 6 -->
        <!-- Comment 7 -->
        <span>Some span</span>
        <!-- Comment 8 -->
      </body>
    </html>
    """

    assert_achievement_not_earned(CommentatorInChief, html)
  end
end