defmodule Divsoup.Achievement.DivSoupBronzeTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.DivSoupBronze

  test "earns achievement when more than 25% of elements are divs" do
    html = """
    <html>
      <body>
        <div>div 1</div>
        <div>div 2</div>
        <div>div 3</div>
        <div>div 4</div>
        <p>paragraph 1</p>
        <p>paragraph 2</p>
        <p>paragraph 3</p>
        <h1>heading 1</h1>
        <h2>heading 2</h2>
        <span>span 1</span>
      </body>
    </html>
    """

    assert_achievement_earned(DivSoupBronze, html)
  end

  test "doesn't earn achievement when less than 25% of elements are divs" do
    html = """
    <html>
      <body>
        <div>div 1</div>
        <p>paragraph 1</p>
        <p>paragraph 2</p>
        <p>paragraph 3</p>
        <p>paragraph 4</p>
        <span>span 1</span>
        <span>span 2</span>
      </body>
    </html>
    """

    assert_achievement_not_earned(DivSoupBronze, html)
  end
end

