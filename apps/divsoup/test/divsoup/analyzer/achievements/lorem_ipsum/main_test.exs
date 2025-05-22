defmodule Divsoup.Achievement.LoremIpsumTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.LoremIpsum

  test "earns achievement when page contains 'lorem ipsum'" do
    html = """
    <html>
      <body>
        <div>This is a page with Lorem Ipsum text.</div>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
      </body>
    </html>
    """

    assert_achievement_earned(LoremIpsum, html)
  end

  test "doesn't earn achievement when page doesn't contain 'lorem ipsum'" do
    html = """
    <html>
      <body>
        <div>This is a page without the placeholder text.</div>
        <p>This is just some regular content without the special phrase.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(LoremIpsum, html)
  end
end

