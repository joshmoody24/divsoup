defmodule Divsoup.Achievement.QuirkyTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.Quirky

  test "earns achievement when page doesn't have DOCTYPE html declaration" do
    html = """
    <html>
      <head>
        <title>Quirks Mode Page</title>
      </head>
      <body>
        <div>This page will render in quirks mode!</div>
      </body>
    </html>
    """

    assert_achievement_earned(Quirky, html)
  end

  test "doesn't earn achievement when page has DOCTYPE html declaration" do
    html = """
    <!DOCTYPE html>
    <html>
      <head>
        <title>Standards Mode Page</title>
      </head>
      <body>
        <div>This page will render in standards mode!</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(Quirky, html)
  end
end