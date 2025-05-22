defmodule Divsoup.Achievement.BobRossTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.BobRoss

  test "earns achievement when page has canvas element" do
    html = """
    <html>
      <head>
        <title>Canvas Art</title>
      </head>
      <body>
        <h1>Interactive Drawing</h1>
        <canvas id="myCanvas" width="400" height="300"></canvas>
        <script>
          // Canvas drawing logic would go here
        </script>
      </body>
    </html>
    """

    assert_achievement_earned(BobRoss, html)
  end

  test "earns achievement when page has picture element" do
    html = """
    <html>
      <head>
        <title>Responsive Images</title>
      </head>
      <body>
        <h1>Photo Gallery</h1>
        <picture>
          <source srcset="large.jpg" media="(min-width: 800px)">
          <source srcset="medium.jpg" media="(min-width: 600px)">
          <img src="small.jpg" alt="A beautiful landscape">
        </picture>
      </body>
    </html>
    """

    assert_achievement_earned(BobRoss, html)
  end

  test "doesn't earn achievement when page has neither canvas nor picture elements" do
    html = """
    <html>
      <head>
        <title>No Canvas or Picture</title>
      </head>
      <body>
        <h1>Regular Page</h1>
        <p>This page has regular content but no canvas or picture elements.</p>
        <img src="image.jpg" alt="Just a regular image">
      </body>
    </html>
    """

    assert_achievement_not_earned(BobRoss, html)
  end
end