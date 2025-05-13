defmodule Divsoup.Achievement.DynamicContentTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.DynamicContent

  test "earns achievement when page has output element" do
    html = """
    <html>
      <head>
        <title>Dynamic Content Test</title>
      </head>
      <body>
        <form oninput="result.value=parseInt(a.value)+parseInt(b.value)">
          <input type="range" id="a" value="50"> +
          <input type="number" id="b" value="25"> =
          <output name="result" for="a b">75</output>
        </form>
      </body>
    </html>
    """

    assert_achievement_earned(DynamicContent, html)
  end

  test "earns achievement with multiple output elements" do
    html = """
    <html>
      <head>
        <title>Dynamic Content Test</title>
      </head>
      <body>
        <form>
          <div>
            <label>Calculate: </label>
            <input type="number" id="num1" value="10"> +
            <input type="number" id="num2" value="20"> =
            <output id="sum">30</output>
          </div>
          <div>
            <label>Temperature in Fahrenheit: </label>
            <input type="number" id="fahrenheit" value="32">
            <label>equals Celsius: </label>
            <output id="celsius">0</output>
          </div>
        </form>
      </body>
    </html>
    """

    assert_achievement_earned(DynamicContent, html)
  end

  test "doesn't earn achievement without output element" do
    html = """
    <html>
      <head>
        <title>Dynamic Content Test</title>
      </head>
      <body>
        <form>
          <div>
            <label>Calculate: </label>
            <input type="number" id="num1" value="10"> +
            <input type="number" id="num2" value="20"> =
            <span id="sum">30</span>
          </div>
        </form>
      </body>
    </html>
    """

    assert_achievement_not_earned(DynamicContent, html)
  end
end