defmodule Divsoup.Achievement.ClassyBronzeTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.ClassyBronze

  test "earns achievement when classes make up more than 10% of page size" do
    html = """
    <html>
      <body>
        <div class="container very-large-class-name super-important-wrapper layout-main">
          <div class="header">Header</div>
          <div class="content-area primary-section">
            <p class="text introduction">This page has many classes</p>
          </div>
          <div class="footer copyright">Footer</div>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(ClassyBronze, html)
  end

  test "doesn't earn achievement when classes make up less than 10% of page size" do
    html = """
    <html>
      <body>
        <div>
          <h1>Simple Page</h1>
          <p>This page has very few classes.</p>
          <div class="small">Just one tiny class here.</div>
          <ul>
            <li>Item 1</li>
            <li>Item 2</li>
            <li>Item 3</li>
            <li>Item 4</li>
          </ul>
          <p>More content without any classes</p>
          <p>Even more content to dilute the class ratio</p>
          <p>Adding extra text to make sure the ratio is below 10%</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(ClassyBronze, html)
  end
end