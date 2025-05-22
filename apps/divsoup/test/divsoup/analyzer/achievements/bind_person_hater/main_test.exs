defmodule Divsoup.Achievement.BlindPersonHaterTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.BlindPersonHater

  test "earns achievement when majority of images lack alt tags and no ARIA attributes" do
    html = """
    <html>
      <body>
        <h1>Inaccessible Page</h1>
        <img src="image1.jpg">
        <img src="image2.jpg" alt="">
        <img src="image3.jpg" alt="description">
        <div>Some content here</div>
      </body>
    </html>
    """

    assert_achievement_earned(BlindPersonHater, html)
  end

  test "doesn't earn achievement when images have alt tags" do
    html = """
    <html>
      <body>
        <h1>Accessible Images</h1>
        <img src="image1.jpg" alt="Description of image 1">
        <img src="image2.jpg" alt="Description of image 2">
        <div>Some content here</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(BlindPersonHater, html)
  end

  test "doesn't earn achievement with ARIA attributes" do
    html = """
    <html>
      <body>
        <h1>Page with ARIA</h1>
        <img src="image1.jpg">
        <img src="image2.jpg" alt="">
        <button aria-label="Close dialog" aria-pressed="false">X</button>
        <div aria-hidden="true">Hidden content</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(BlindPersonHater, html)
  end

  test "doesn't earn achievement with both alt tags and ARIA attributes" do
    html = """
    <html>
      <body>
        <h1>Accessible Page</h1>
        <img src="image1.jpg" alt="First image">
        <img src="image2.jpg" alt="Second image">
        <div aria-live="polite">Updated content will be announced</div>
        <button aria-expanded="false">Show more</button>
      </body>
    </html>
    """

    assert_achievement_not_earned(BlindPersonHater, html)
  end
end