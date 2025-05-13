defmodule Divsoup.Achievement.SoapBoxTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.SoapBox

  test "earns achievement with HTML comment containing more than 100 words" do
    # Generate a long comment with 105 words
    long_comment = Enum.map_join(1..105, " ", fn i -> "word#{i}" end)

    html = """
    <html>
      <head>
        <title>Soap Box Test</title>
      </head>
      <body>
        <h1>Soap Box Example</h1>
        <!-- #{long_comment} -->
        <p>Some visible content</p>
      </body>
    </html>
    """

    assert_achievement_earned(SoapBox, html)
  end

  test "earns achievement with multiple comments, one of which is long" do
    # Generate a long comment with 101 words
    long_comment = Enum.map_join(1..101, " ", fn i -> "word#{i}" end)

    html = """
    <html>
      <head>
        <title>Soap Box Test</title>
        <!-- A short comment -->
      </head>
      <body>
        <h1>Soap Box Example</h1>
        <!-- Another short comment -->
        <p>Some content</p>
        <!-- #{long_comment} -->
        <p>More content</p>
        <!-- Yet another short comment -->
      </body>
    </html>
    """

    assert_achievement_earned(SoapBox, html)
  end

  test "doesn't earn achievement when comments are short" do
    html = """
    <html>
      <head>
        <title>Soap Box Test</title>
        <!-- This is a short comment -->
      </head>
      <body>
        <h1>Soap Box Example</h1>
        <!-- 
          This is a multi-line comment
          with several lines
          but still fewer than 100 words.
          It only has about 30 words total which is not enough to earn the achievement.
          We need many more words to reach the 100 word threshold for this test.
          Still not enough!
        -->
        <p>Some visible content</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(SoapBox, html)
  end
end