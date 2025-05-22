defmodule Divsoup.Achievement.MasterOfElements.PlatinumTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.MasterOfElements.Platinum
  alias Divsoup.Util.Html

  test "earns achievement with all possible HTML elements" do
    # Get all HTML elements (standard, deprecated, and experimental)
    all_elements = Html.all_elements()
    
    # Create HTML with all these elements
    element_tags = all_elements
    |> Enum.map(fn elem -> "<#{elem}></#{elem}>" end)
    |> Enum.join("\n      ")
    
    html = """
    <html>
      <head>
        <title>Platinum Elements Test</title>
      </head>
      <body>
        <div id="container">
          #{element_tags}
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(Platinum, html)
  end

  test "doesn't earn achievement without all possible elements" do
    # Generate HTML with about 30 different elements
    html = """
    <html>
      <head>
        <title>Not All Elements</title>
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

    assert_achievement_not_earned(Platinum, html)
  end
  
  test "missing just one element doesn't earn achievement" do
    # Get all HTML elements except one
    all_elements = Html.all_elements()
    elements_except_one = Enum.drop(all_elements, 1)
    
    # Create HTML with all elements except one
    element_tags = elements_except_one
    |> Enum.map(fn elem -> "<#{elem}></#{elem}>" end)
    |> Enum.join("\n      ")
    
    html = """
    <html>
      <head>
        <title>Almost Platinum Test</title>
      </head>
      <body>
        <div id="container">
          #{element_tags}
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(Platinum, html)
  end
end