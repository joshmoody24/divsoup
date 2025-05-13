defmodule Divsoup.Achievement.WeDoThingsALittleDifferentTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.WeDoThingsALittleDifferent

  test "earns achievement when div is nested inside a span" do
    html = """
    <html>
      <head>
        <title>Nesting Test</title>
      </head>
      <body>
        <p>Some content here</p>
        <span>
          <div>This div is inside a span</div>
        </span>
        <p>More content here</p>
      </body>
    </html>
    """

    assert_achievement_earned(WeDoThingsALittleDifferent, html)
  end

  test "earns achievement with multiple nested divs in spans" do
    html = """
    <html>
      <head>
        <title>Nesting Test</title>
      </head>
      <body>
        <span>Normal span</span>
        <span>
          <div>First nested div</div>
          <div>Second nested div</div>
        </span>
        <div>
          <span>This is fine, span in div</span>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(WeDoThingsALittleDifferent, html)
  end

  test "doesn't earn achievement without divs inside spans" do
    html = """
    <html>
      <head>
        <title>Nesting Test</title>
      </head>
      <body>
        <span>Normal span</span>
        <div>
          <span>This is a normal layout, span in div</span>
        </div>
        <span>Another normal span</span>
      </body>
    </html>
    """

    assert_achievement_not_earned(WeDoThingsALittleDifferent, html)
  end
end