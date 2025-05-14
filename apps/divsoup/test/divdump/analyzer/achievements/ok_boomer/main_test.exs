defmodule Divsoup.Achievement.OkBoomerTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.OkBoomer

  test "earns achievement when page uses deprecated center element" do
    html = """
    <html>
      <head>
        <title>Centered Text</title>
      </head>
      <body>
        <center>This text is centered using a deprecated element</center>
        <p>Regular paragraph</p>
      </body>
    </html>
    """

    assert_achievement_earned(OkBoomer, html)
  end

  test "earns achievement when page uses deprecated font element" do
    html = """
    <html>
      <head>
        <title>Font Element</title>
      </head>
      <body>
        <p>Regular paragraph</p>
        <p><font color="red" size="5">This uses the deprecated font element</font></p>
      </body>
    </html>
    """

    assert_achievement_earned(OkBoomer, html)
  end

  test "earns achievement when page uses deprecated marquee element" do
    html = """
    <html>
      <head>
        <title>Marquee Text</title>
      </head>
      <body>
        <marquee>This text scrolls using a deprecated element</marquee>
        <p>Regular paragraph</p>
      </body>
    </html>
    """

    assert_achievement_earned(OkBoomer, html)
  end

  test "doesn't earn achievement when page uses only standard elements" do
    html = """
    <html>
      <head>
        <title>Modern HTML</title>
      </head>
      <body>
        <header>
          <h1>Modern HTML Page</h1>
        </header>
        <main>
          <p>This page uses only standard HTML elements.</p>
          <div class="centered">
            <p>Text centered using CSS, not deprecated center element</p>
          </div>
          <section>
            <h2>Section Title</h2>
            <p>More content using standard elements.</p>
          </section>
        </main>
        <footer>
          <p>Footer content</p>
        </footer>
      </body>
    </html>
    """

    assert_achievement_not_earned(OkBoomer, html)
  end
end