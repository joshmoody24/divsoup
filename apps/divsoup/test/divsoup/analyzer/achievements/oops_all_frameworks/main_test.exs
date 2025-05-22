defmodule Divsoup.Achievement.OopsAllFrameworksTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.OopsAllFrameworks

  test "earns achievement when page has React, Vue, and Angular" do
    html = """
    <html>
      <head>
        <title>Oops, All Frameworks Test</title>
        <script src="react.js"></script>
        <script src="angular.js"></script>
        <script src="vue.js"></script>
      </head>
      <body>
        <div data-reactroot>React component</div>
        <div ng-app="myApp">Angular component</div>
        <div v-if="true">Vue component</div>
      </body>
    </html>
    """

    assert_achievement_earned(OopsAllFrameworks, html)
  end

  test "doesn't earn achievement with only React and Vue" do
    html = """
    <html>
      <head>
        <title>Oops, All Frameworks Test</title>
        <script src="react.js"></script>
        <script src="vue.js"></script>
      </head>
      <body>
        <div data-reactroot>React component</div>
        <div v-if="true">Vue component</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(OopsAllFrameworks, html)
  end

  test "doesn't earn achievement with no frameworks" do
    html = """
    <html>
      <head>
        <title>Oops, All Frameworks Test</title>
        <script src="jquery.js"></script>
      </head>
      <body>
        <div>No frameworks here</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(OopsAllFrameworks, html)
  end
end