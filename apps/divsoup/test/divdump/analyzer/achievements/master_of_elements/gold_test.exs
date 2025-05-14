defmodule Divsoup.Achievement.MasterOfElements.GoldTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.MasterOfElements.Gold
  alias Divsoup.Util.Html

  test "earns achievement with exactly 118 different valid elements" do
    # Get as many standard elements as possible, plus some deprecated ones to reach 118
    standard_elements = Html.standard_elements()
    
    # If we don't have enough standard elements, add some deprecated ones
    num_standard = length(standard_elements)
    
    elements = if num_standard >= 118 do
      Enum.take_random(standard_elements, 118)
    else
      # Add deprecated elements to get to 118
      deprecated_needed = 118 - num_standard
      deprecated_elements = Html.deprecated_elements() |> Enum.take(deprecated_needed)
      standard_elements ++ deprecated_elements
    end
    
    # Create HTML with exactly these elements
    element_tags = elements
    |> Enum.map(fn elem -> "<#{elem}></#{elem}>" end)
    |> Enum.join("\n      ")
    
    html = """
    <html>
      <head>
        <title>Gold Elements Test</title>
      </head>
      <body>
        <div id="container">
          #{element_tags}
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(Gold, html)
  end

  test "doesn't earn achievement with fewer than 118 elements" do
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

    assert_achievement_not_earned(Gold, html)
  end
end