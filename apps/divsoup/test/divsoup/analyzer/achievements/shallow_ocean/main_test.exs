defmodule Divsoup.Achievement.ShallowOceanTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.ShallowOcean

  test "earns achievement with flat DOM structure" do
    html = """
    <html>
      <head>
        <title>Shallow Ocean Test</title>
      </head>
      <body>
        <div>First child</div>
        <p>Second child</p>
        <span>Third child</span>
        <h1>Fourth child</h1>
        <h2>Fifth child</h2>
        <ul>
          <li>List item</li>
          <li>List item</li>
        </ul>
      </body>
    </html>
    """

    assert_achievement_earned(ShallowOcean, html)
  end

  test "earns achievement with mostly shallow structure" do
    html = """
    <html>
      <head>
        <title>Shallow Ocean Test</title>
      </head>
      <body>
        <div>First child</div>
        <p>Second child</p>
        <span>Third child</span>
        <div>
          <div>
            <span>Deeper element</span>
          </div>
        </div>
        <h1>Fourth child</h1>
        <h2>Fifth child</h2>
        <h3>Sixth child</h3>
        <h4>Seventh child</h4>
        <h5>Eighth child</h5>
      </body>
    </html>
    """

    assert_achievement_earned(ShallowOcean, html)
  end

  test "doesn't earn achievement with deep DOM structure" do
    html = """
    <html>
      <head>
        <title>Deep DOM Test</title>
      </head>
      <body>
        <div>
          <div>
            <div>
              <div>
                <div>
                  <div>
                    <p>Very deep element</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div>
          <div>
            <div>
              <p>Another deep element</p>
            </div>
          </div>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(ShallowOcean, html)
  end

  test "doesn't earn achievement with empty body" do
    html = """
    <html>
      <head>
        <title>Empty Body Test</title>
      </head>
      <body>
      </body>
    </html>
    """

    assert_achievement_not_earned(ShallowOcean, html)
  end
end