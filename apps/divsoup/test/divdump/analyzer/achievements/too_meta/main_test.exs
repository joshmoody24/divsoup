defmodule Divsoup.Achievement.TooMetaTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.TooMeta

  test "earns achievement when head has 8 or more meta elements" do
    html = """
    <html>
      <head>
        <title>Too Meta Test</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Test page">
        <meta name="keywords" content="test, meta, elements">
        <meta name="author" content="Test Author">
        <meta property="og:title" content="Test Title">
        <meta property="og:description" content="Test Description">
        <meta property="og:image" content="image.jpg">
        <meta name="twitter:card" content="summary_large_image">
      </head>
      <body>
        <div>Content</div>
      </body>
    </html>
    """

    assert_achievement_earned(TooMeta, html)
  end

  test "doesn't earn achievement when head has fewer than 8 meta elements" do
    html = """
    <html>
      <head>
        <title>Too Meta Test</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Test page">
        <meta name="keywords" content="test, meta, elements">
        <meta name="author" content="Test Author">
        <meta property="og:title" content="Test Title">
      </head>
      <body>
        <div>Content</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(TooMeta, html)
  end
end