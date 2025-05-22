defmodule Divsoup.Achievement.BackwardsCompatibilityTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.BackwardsCompatibility

  test "earns achievement with IE conditional comment" do
    html = """
    <html>
      <head>
        <title>Backwards Compatibility Test</title>
        <!--[if IE]>
        <link rel="stylesheet" type="text/css" href="ie-only.css" />
        <![endif]-->
      </head>
      <body>
        <div>Regular content</div>
      </body>
    </html>
    """

    assert_achievement_earned(BackwardsCompatibility, html)
  end

  test "earns achievement with multiple IE conditional comments" do
    html = """
    <html>
      <head>
        <title>Backwards Compatibility Test</title>
        <!--[if IE]>
        <link rel="stylesheet" type="text/css" href="ie-only.css" />
        <![endif]-->
      </head>
      <body>
        <div>Regular content</div>
        <!--[if IE 6]>
        <div>You're using Internet Explorer 6</div>
        <![endif]-->
        <!--[if IE 8]>
        <div>You're using Internet Explorer 8</div>
        <![endif]-->
      </body>
    </html>
    """

    assert_achievement_earned(BackwardsCompatibility, html)
  end

  test "doesn't earn achievement without IE conditional comments" do
    html = """
    <html>
      <head>
        <title>Backwards Compatibility Test</title>
        <!-- Regular comment -->
      </head>
      <body>
        <div>Regular content</div>
        <!-- Another regular comment -->
      </body>
    </html>
    """

    assert_achievement_not_earned(BackwardsCompatibility, html)
  end
end