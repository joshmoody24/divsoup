defmodule Divsoup.Achievement.SemanticPsychopathPlatinumTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.SemanticPsychopathPlatinum

  test "earns achievement when page has all semantic elements and no divs or spans" do
    html = """
    <html>
      <head>
        <title>Semantic Psychopath Test</title>
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

    assert_achievement_earned(SemanticPsychopathPlatinum, html)
  end

  test "doesn't earn achievement when missing semantic elements" do
    html = """
    <html>
      <head>
        <title>Semantic Psychopath Test</title>
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
          <section>
            <h3>Section Heading</h3>
            <p>Section content</p>
          </section>
        </main>
        <footer>
          <p>&copy; 2025 Test Site</p>
        </footer>
      </body>
    </html>
    """

    assert_achievement_not_earned(SemanticPsychopathPlatinum, html)
  end

  test "doesn't earn achievement when containing div or span" do
    html = """
    <html>
      <head>
        <title>Semantic Psychopath Test</title>
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
              <p>Section content with <span>highlighted text</span></p>
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

    assert_achievement_not_earned(SemanticPsychopathPlatinum, html)
  end
end