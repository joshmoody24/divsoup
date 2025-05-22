defmodule Divsoup.Achievement.MasterOfElements.SilverTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.MasterOfElements.Silver
  alias Divsoup.Util.Html

  test "earns achievement with exactly 60 different valid elements" do
    # Get 60 standard elements from the HTML util for a positive test
    standard_elements = Html.standard_elements()
    |> Enum.take_random(60)
    
    # Create HTML with exactly these 60 elements
    element_tags = standard_elements
    |> Enum.map(fn elem -> "<#{elem}></#{elem}>" end)
    |> Enum.join("\n      ")
    
    html = """
    <html>
      <head>
        <title>Silver Elements Test</title>
      </head>
      <body>
        <div id="container">
          #{element_tags}
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(Silver, html)
  end

  test "doesn't earn achievement with fewer than 60 elements" do
    # Generate HTML with about 30 different elements
    html = """
    <html>
      <head>
        <title>Not Enough Elements</title>
        <meta charset="utf-8">
        <link rel="stylesheet" href="styles.css">
        <style>.test{color:red;}</style>
        <script>console.log('test');</script>
      </head>
      <body>
        <header><h1>Testing Elements</h1></header>
        <nav><a href="#">Home</a></nav>
        <main>
          <section>
            <p>This is a <strong>test</strong> of <em>various</em> elements.</p>
            <div>
              <article>
                <h2>Subtitle</h2>
                <ul>
                  <li>List item 1</li>
                  <li>List item 2</li>
                </ul>
                <ol>
                  <li>Ordered item 1</li>
                  <li>Ordered item 2</li>
                </ol>
                <table>
                  <tr><th>Header</th></tr>
                  <tr><td>Cell</td></tr>
                </table>
              </article>
            </div>
            <aside>Sidebar content</aside>
          </section>
        </main>
        <footer>&copy; 2025</footer>
      </body>
    </html>
    """

    assert_achievement_not_earned(Silver, html)
  end
end