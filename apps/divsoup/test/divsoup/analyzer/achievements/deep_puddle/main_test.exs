defmodule Divsoup.Achievement.DeepPuddleTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.DeepPuddle

  test "earns achievement with long single-child chain" do
    html = """
    <html>
      <head>
        <title>Deep Puddle Test</title>
      </head>
      <body>
        <div>
          <div>
            <div>
              <div>
                <div>
                  <div>
                    <div>
                      <div>
                        <p>Element at the end of a long chain</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(DeepPuddle, html)
  end

  test "earns achievement with long single-child chain branching off" do
    html = """
    <html>
      <head>
        <title>Deep Puddle Test with Branch</title>
      </head>
      <body>
        <header>Site header</header>
        <main>
          <article>
            <section>
              <div>
                <div>
                  <div>
                    <div>
                      <div>
                        <p>Element at the end of a long chain</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </section>
          </article>
        </main>
        <footer>Site footer</footer>
      </body>
    </html>
    """

    assert_achievement_earned(DeepPuddle, html)
  end

  test "doesn't earn achievement with too short chain" do
    html = """
    <html>
      <head>
        <title>Short Chain Test</title>
      </head>
      <body>
        <div>
          <div>
            <div>
              <div>
                <p>Element at the end of a short chain</p>
              </div>
            </div>
          </div>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(DeepPuddle, html)
  end

  test "doesn't earn achievement with multiple children" do
    html = """
    <html>
      <head>
        <title>Multiple Children Test</title>
      </head>
      <body>
        <div>
          <div>
            <div>
              <div>
                <div>
                  <div>
                    <div>
                      <div>
                        <p>First child</p>
                        <p>Second child - breaks the chain</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(DeepPuddle, html)
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

    assert_achievement_not_earned(DeepPuddle, html)
  end
end