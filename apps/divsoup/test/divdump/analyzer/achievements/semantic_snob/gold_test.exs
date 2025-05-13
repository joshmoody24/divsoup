defmodule Divsoup.Achievement.SemanticSnobGoldTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.SemanticSnobGold

  test "earns achievement when page has all required semantic elements" do
    html = """
    <html>
      <head>
        <title>Semantic Snob Test</title>
      </head>
      <body>
        <header>
          <h1>Site Header</h1>
        </header>
        <nav>
          <ul>
            <li><a href="/">Home</a></li>
            <li><a href="/about">About</a></li>
          </ul>
        </nav>
        <main>
          <article>
            <h2>Article Title</h2>
            <section>
              <h3>Section Heading</h3>
              <p>Section content</p>
            </section>
          </article>
          <aside>
            <h3>Related Content</h3>
            <p>Sidebar content</p>
          </aside>
        </main>
        <footer>
          <p>&copy; 2025 Test Site</p>
        </footer>
      </body>
    </html>
    """

    assert_achievement_earned(SemanticSnobGold, html)
  end

  test "doesn't earn achievement when missing one or more semantic elements" do
    html = """
    <html>
      <head>
        <title>Semantic Snob Test</title>
      </head>
      <body>
        <header>
          <h1>Site Header</h1>
        </header>
        <nav>
          <ul>
            <li><a href="/">Home</a></li>
          </ul>
        </nav>
        <main>
          <div>
            <h2>Article Title</h2>
            <section>
              <h3>Section Heading</h3>
              <p>Section content</p>
            </section>
          </div>
        </main>
        <footer>
          <p>&copy; 2025 Test Site</p>
        </footer>
      </body>
    </html>
    """

    assert_achievement_not_earned(SemanticSnobGold, html)
  end
end