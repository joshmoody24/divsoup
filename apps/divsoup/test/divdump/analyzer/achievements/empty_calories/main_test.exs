defmodule Divsoup.Achievement.EmptyCaloriesTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.EmptyCalories

  test "earns achievement with 10 or more empty divs and spans" do
    html = """
    <html>
      <head>
        <title>Empty Calories Test</title>
      </head>
      <body>
        <div></div>
        <div></div>
        <div> </div>
        <span></span>
        <span> </span>
        <div class="empty"></div>
        <span id="empty"></span>
        <div></div>
        <span></span>
        <div></div>
        <span></span>
        <p>This is not empty</p>
      </body>
    </html>
    """

    assert_achievement_earned(EmptyCalories, html)
  end

  test "doesn't earn achievement with fewer than 10 empty elements" do
    html = """
    <html>
      <head>
        <title>Empty Calories Test</title>
      </head>
      <body>
        <div></div>
        <div></div>
        <div> </div>
        <span></span>
        <span> </span>
        <div class="empty"></div>
        <span id="empty"></span>
        <p>This is not empty</p>
        <div>Not empty</div>
        <span>Not empty</span>
      </body>
    </html>
    """

    assert_achievement_not_earned(EmptyCalories, html)
  end

  test "doesn't count elements with content as empty" do
    html = """
    <html>
      <head>
        <title>Empty Calories Test</title>
      </head>
      <body>
        <div></div>
        <div></div>
        <div>Not empty</div>
        <span></span>
        <span>Not empty</span>
        <div><img src="image.jpg"></div>
        <span><a href="#">Link</a></span>
        <div></div>
        <span></span>
      </body>
    </html>
    """

    assert_achievement_not_earned(EmptyCalories, html)
  end
end