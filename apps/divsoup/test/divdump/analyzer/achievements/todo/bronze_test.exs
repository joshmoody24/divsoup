defmodule Divsoup.Achievement.TodoBronzeTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.TodoBronze

  test "earns achievement when page contains TODO" do
    html = """
    <html>
      <body>
        <h1>Project Page</h1>
        <div>
          <h2>Features</h2>
          <ul>
            <li>Login functionality</li>
            <li>User dashboard</li>
            <li>TODO: Implement password reset</li>
          </ul>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(TodoBronze, html)
  end

  test "earns achievement with different casing of TODO" do
    html = """
    <html>
      <body>
        <h1>Development Notes</h1>
        <p>todo: Add more content to this section</p>
        <div>Current work in progress</div>
      </body>
    </html>
    """

    assert_achievement_earned(TodoBronze, html)
  end

  test "earns achievement with TODO in comments" do
    html = """
    <html>
      <head>
        <title>My Site</title>
        <!-- TODO: Add meta tags for SEO -->
      </head>
      <body>
        <h1>Welcome</h1>
        <p>This is my website.</p>
      </body>
    </html>
    """

    assert_achievement_earned(TodoBronze, html)
  end

  test "doesn't earn achievement when page doesn't contain TODO" do
    html = """
    <html>
      <body>
        <h1>Completed Project</h1>
        <p>All features have been implemented.</p>
        <div>No outstanding tasks remain.</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(TodoBronze, html)
  end
end