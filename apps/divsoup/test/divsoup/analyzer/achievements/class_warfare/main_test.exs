defmodule Divsoup.Achievement.ClassWarfareTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.ClassWarfare

  test "earns achievement when an element has more than 50 classes" do
    # Generate 55 classes
    many_classes = Enum.map_join(1..55, " ", fn i -> "class-#{i}" end)

    html = """
    <html>
      <head>
        <title>Class Warfare Test</title>
      </head>
      <body>
        <div class="#{many_classes}">
          This element has way too many classes
        </div>
        <p class="normal-class">This is normal</p>
      </body>
    </html>
    """

    assert_achievement_earned(ClassWarfare, html)
  end

  test "doesn't earn achievement when no element has more than 50 classes" do
    # Generate 45 classes
    many_classes = Enum.map_join(1..45, " ", fn i -> "class-#{i}" end)

    html = """
    <html>
      <head>
        <title>Class Warfare Test</title>
      </head>
      <body>
        <div class="#{many_classes}">
          This element has many classes, but not enough
        </div>
        <p class="a b c d e f g h i j">This has 10 classes</p>
        <span class="k l m n o p q r s t">This has 10 more classes</span>
      </body>
    </html>
    """

    assert_achievement_not_earned(ClassWarfare, html)
  end

  test "doesn't earn achievement with no classes" do
    html = """
    <html>
      <head>
        <title>Class Warfare Test</title>
      </head>
      <body>
        <div>No classes here</div>
        <p>None here either</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(ClassWarfare, html)
  end
end