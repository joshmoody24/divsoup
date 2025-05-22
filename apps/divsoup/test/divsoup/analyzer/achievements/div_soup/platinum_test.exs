defmodule Divsoup.Achievement.DivSoupPlatinumTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.DivSoupPlatinum

  test "earns achievement when more than 90% of elements are divs" do
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
        <div>div 15</div>
        <div>div 16</div>
        <div>div 17</div>
        <div>div 18</div>
        <div>div 19</div>
        <div>div 20</div>
        <div>div 21</div>
        <div>div 22</div>
        <div>div 23</div>
        <div>div 24</div>
        <div>div 25</div>
        <div>div 26</div>
        <div>div 27</div>
        <div>div 28</div>
        <div>div 29</div>
        <div>div 30</div>
      </body>
    </html>
    """
    
    assert_achievement_earned(DivSoupPlatinum, html)
  end

  test "doesn't earn achievement when less than 90% of elements are divs" do
    html = """
    <html>
      <body>
        <div>div 1</div>
        <div>div 2</div>
        <div>div 3</div>
        <div>div 4</div>
        <div>div 5</div>
        <div>div 6</div>
        <p>paragraph 1</p>
        <p>paragraph 2</p>
      </body>
    </html>
    """
    
    assert_achievement_not_earned(DivSoupPlatinum, html)
  end
end