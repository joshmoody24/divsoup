defmodule Divsoup.Achievement.YouAreAmazingEmbedTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.YouAreAmazingEmbed

  test "earns achievement when page has iframe element" do
    html = """
    <html>
      <body>
        <h1>Welcome to my page</h1>
        <iframe src="https://www.youtube.com/embed/dQw4w9WgXcQ" width="560" height="315"></iframe>
        <p>Check out this cool video!</p>
      </body>
    </html>
    """

    assert_achievement_earned(YouAreAmazingEmbed, html)
  end

  test "earns achievement when page has embed element" do
    html = """
    <html>
      <body>
        <h1>Flash Game</h1>
        <embed src="game.swf" width="550" height="400" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash">
      </body>
    </html>
    """

    assert_achievement_earned(YouAreAmazingEmbed, html)
  end

  test "earns achievement when page has object element" do
    html = """
    <html>
      <body>
        <h1>PDF Viewer</h1>
        <object data="document.pdf" type="application/pdf" width="800" height="600">
          <p>Your browser doesn't support PDFs. <a href="document.pdf">Download the PDF</a>.</p>
        </object>
      </body>
    </html>
    """

    assert_achievement_earned(YouAreAmazingEmbed, html)
  end

  test "doesn't earn achievement when page has no embed elements" do
    html = """
    <html>
      <body>
        <h1>Simple Page</h1>
        <p>This page has no embedded content.</p>
        <div>Just some plain HTML.</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(YouAreAmazingEmbed, html)
  end
end