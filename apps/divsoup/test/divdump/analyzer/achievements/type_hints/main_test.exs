defmodule Divsoup.Achievement.TypeHintsTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.TypeHints

  test "earns achievement when page has a datalist element" do
    html = """
    <html>
      <head>
        <title>Type Hints Test</title>
      </head>
      <body>
        <form>
          <label for="browser">Choose your browser from the list:</label>
          <input list="browsers" name="browser" id="browser">
          <datalist id="browsers">
            <option value="Edge">
            <option value="Firefox">
            <option value="Chrome">
            <option value="Safari">
            <option value="Opera">
          </datalist>
          <button type="submit">Submit</button>
        </form>
      </body>
    </html>
    """

    assert_achievement_earned(TypeHints, html)
  end

  test "earns achievement with empty datalist element" do
    html = """
    <html>
      <head>
        <title>Type Hints Test</title>
      </head>
      <body>
        <form>
          <label for="color">Choose a color:</label>
          <input list="colors" name="color" id="color">
          <datalist id="colors">
            <!-- Empty datalist -->
          </datalist>
          <button type="submit">Submit</button>
        </form>
      </body>
    </html>
    """

    assert_achievement_earned(TypeHints, html)
  end

  test "doesn't earn achievement without datalist element" do
    html = """
    <html>
      <head>
        <title>Type Hints Test</title>
      </head>
      <body>
        <form>
          <label for="browser">Choose your browser:</label>
          <select name="browser" id="browser">
            <option value="edge">Edge</option>
            <option value="firefox">Firefox</option>
            <option value="chrome">Chrome</option>
            <option value="safari">Safari</option>
            <option value="opera">Opera</option>
          </select>
          <button type="submit">Submit</button>
        </form>
      </body>
    </html>
    """

    assert_achievement_not_earned(TypeHints, html)
  end
end