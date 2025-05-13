defmodule Divsoup.Achievement.TestInProdTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.TestInProd

  test "earns achievement when page has console.log statements" do
    html = """
    <html>
      <head>
        <title>Test in Prod</title>
        <script>
          function init() {
            console.log('Page loaded');
            const data = fetchData();
            console.log('Data:', data);
          }
        </script>
      </head>
      <body>
        <h1>Test in Prod Example</h1>
        <script>
          console.log("Another log message");
        </script>
      </body>
    </html>
    """

    assert_achievement_earned(TestInProd, html)
  end

  test "earns achievement with different console.log formatting" do
    html = """
    <html>
      <head>
        <title>Test in Prod</title>
        <script>
          function init() {
            console.log(`Template literal log`);
            console.log("Double quotes");
            console.log('Single quotes');
            console.log("Multiple", "arguments", 123);
          }
        </script>
      </head>
      <body>
        <h1>Test in Prod Example</h1>
      </body>
    </html>
    """

    assert_achievement_earned(TestInProd, html)
  end

  test "doesn't earn achievement without console.log statements" do
    html = """
    <html>
      <head>
        <title>Test in Prod</title>
        <script>
          function init() {
            // Using proper error handling in production
            try {
              const data = fetchData();
              renderData(data);
            } catch (error) {
              handleError(error);
            }
          }
        </script>
      </head>
      <body>
        <h1>Test in Prod Example</h1>
        <script>
          // Comment explaining what console.log would do
        </script>
      </body>
    </html>
    """

    assert_achievement_not_earned(TestInProd, html)
  end
end