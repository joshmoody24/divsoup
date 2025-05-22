defmodule Divsoup.Achievement.DivSoupSilverTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper
  
  alias Divsoup.Achievement.DivSoupSilver

  test "earns achievement when more than 50% of elements are divs" do
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
        <p>paragraph 1</p>
        <p>paragraph 2</p>
        <p>paragraph 3</p>
        <span>span 1</span>
        <span>span 2</span>
      </body>
    </html>
    """

    assert_achievement_earned(DivSoupSilver, html)
  end

  test "doesn't earn achievement when less than 50% of elements are divs" do
    html = """
    <html>
      <body>
        <div>div 1</div>
        <div>div 2</div>
        <p>paragraph 1</p>
        <p>paragraph 2</p>
        <span>span 1</span>
        <span>span 2</span>
      </body>
    </html>
    """

    assert_achievement_not_earned(DivSoupSilver, html)
  end
end

