defmodule Divsoup.Achievement.MillionthVisitorTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.MillionthVisitor

  test "earns achievement when page has blink element" do
    html = """
    <html>
      <body>
        <h1>Congratulations!</h1>
        <blink>You are our 1,000,000th visitor! Click here to claim your prize!</blink>
        <p>Act now before time runs out!</p>
      </body>
    </html>
    """

    assert_achievement_earned(MillionthVisitor, html)
  end

  test "earns achievement when page has marquee element" do
    html = """
    <html>
      <body>
        <h1>Welcome to our website</h1>
        <marquee direction="left" scrollamount="5">
          Breaking news: You've been selected as our lucky visitor! 
        </marquee>
        <p>Check out our amazing deals!</p>
      </body>
    </html>
    """

    assert_achievement_earned(MillionthVisitor, html)
  end

  test "doesn't earn achievement when page has neither blink nor marquee elements" do
    html = """
    <html>
      <body>
        <h1>Welcome to our modern website</h1>
        <div class="announcement">
          Thank you for visiting our site.
        </div>
        <p>Please explore our content.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(MillionthVisitor, html)
  end
end