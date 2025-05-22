defmodule Divsoup.Achievement.DivSoupGoldTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.DivSoupGold

  test "earns achievement when more than 75% of elements are divs" do
    html = """
    <html>
      <body>
        <div>div 1</div>
        <div>div 2</div>
        <div>div 3</div>
        <div>div 4</div>
        <div>div 5</div>
        <div>div 6</div>
        <div>div 7</div>
        <div>div 8</div>
        <div>div 9</div>
        <div>div 10</div>
        <div>div 11</div>
        <div>div 12</div>
        <div>div 13</div>
        <div>div 14</div>
        <p>paragraph</p>
        <span>span</span>
      </body>
    </html>
    """

    assert_achievement_earned(DivSoupGold, html)
  end

  test "doesn't earn achievement when less than 75% of elements are divs" do
    html = """
    <html>
      <body>
        <div>div 1</div>
        <div>div 2</div>
        <div>div 3</div>
        <p>paragraph 1</p>
        <p>paragraph 2</p>
        <span>span 1</span>
      </body>
    </html>
    """

    assert_achievement_not_earned(DivSoupGold, html)
  end
end

