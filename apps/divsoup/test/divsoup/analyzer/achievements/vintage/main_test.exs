defmodule Divsoup.Achievement.VintageTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.Vintage

  test "earns achievement when page has nested tables" do
    html = """
    <html>
      <body>
        <table border="1">
          <tr>
            <td>
              <table border="1">
                <tr>
                  <td>Nested table content</td>
                </tr>
              </table>
            </td>
            <td>Other cell</td>
          </tr>
        </table>
      </body>
    </html>
    """

    assert_achievement_earned(Vintage, html)
  end

  test "doesn't earn achievement when page has only one table level" do
    html = """
    <html>
      <body>
        <table border="1">
          <tr>
            <td>Cell 1</td>
            <td>Cell 2</td>
          </tr>
          <tr>
            <td>Cell 3</td>
            <td>Cell 4</td>
          </tr>
        </table>
      </body>
    </html>
    """

    assert_achievement_not_earned(Vintage, html)
  end

  test "doesn't earn achievement when page has no tables" do
    html = """
    <html>
      <body>
        <div>Modern layout with divs</div>
        <div>
          <div>Nested div instead of tables</div>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(Vintage, html)
  end
end