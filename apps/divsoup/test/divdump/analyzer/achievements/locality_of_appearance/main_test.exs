defmodule Divsoup.Achievement.LocalityOfAppearanceTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.LocalityOfAppearance

  test "earns achievement when page has more style attributes than class attributes" do
    html = """
    <html>
      <body>
        <div style="font-size: 16px; color: #333; margin: 20px; padding: 15px; background-color: #f5f5f5; border: 1px solid #ddd; border-radius: 5px;">
          <h1 style="color: #555; font-family: Arial, sans-serif;">Inline Styles</h1>
          <p style="line-height: 1.5; text-align: justify;">
            This page uses more inline styles than classes.
          </p>
          <div style="display: flex; justify-content: space-between;">
            <span style="font-weight: bold;">Bold text</span>
            <span class="small">Small class</span>
          </div>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(LocalityOfAppearance, html)
  end

  test "doesn't earn achievement when page has more class attributes than style attributes" do
    html = """
    <html>
      <body>
        <div class="container main-content large-padding rounded shadow">
          <h1 class="title heading-large primary-color">Class-based Styling</h1>
          <p class="text-body paragraph medium-size justified">
            This page uses more classes than inline styles.
          </p>
          <div class="flex-container space-between align-center">
            <span class="bold highlight">Important text</span>
            <span style="color: blue;">Blue text</span>
          </div>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(LocalityOfAppearance, html)
  end

  test "earns achievement with equal amounts of style and class, but longer style attributes" do
    html = """
    <html>
      <body>
        <div class="container" style="margin: 0 auto; max-width: 1200px; padding: 20px; box-sizing: border-box;">
          <h1 class="title" style="font-size: 32px; color: #222; margin-bottom: 30px; font-weight: bold;">
            Equal Elements, Longer Styles
          </h1>
          <p class="text" style="line-height: 1.6; font-family: Arial, sans-serif; color: #444; margin-bottom: 15px;">
            Both elements have class and style, but the style attributes contain more characters.
          </p>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(LocalityOfAppearance, html)
  end

  test "doesn't earn achievement when page has no styles or classes" do
    html = """
    <html>
      <body>
        <h1>Plain HTML</h1>
        <p>This page has no styles or classes at all.</p>
        <div>
          <span>Just plain elements</span>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(LocalityOfAppearance, html)
  end
end