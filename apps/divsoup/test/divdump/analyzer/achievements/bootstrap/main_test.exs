defmodule Divsoup.Achievement.BootstrapTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.Bootstrap

  test "earns achievement when page links to Bootstrap CSS" do
    html = """
    <html>
      <head>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
      </head>
      <body>
        <div class="container">
          <div class="row">
            <div class="col">Content</div>
          </div>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(Bootstrap, html)
  end

  test "earns achievement when page references Bootstrap JS" do
    html = """
    <html>
      <head>
        <title>My Website</title>
      </head>
      <body>
        <div>Some content</div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
      </body>
    </html>
    """

    assert_achievement_earned(Bootstrap, html)
  end

  test "doesn't earn achievement when page doesn't reference Bootstrap" do
    html = """
    <html>
      <head>
        <link rel="stylesheet" href="styles.css">
        <script src="main.js"></script>
      </head>
      <body>
        <div>This page doesn't use Bootstrap.</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(Bootstrap, html)
  end
end