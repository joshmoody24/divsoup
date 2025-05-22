defmodule Divsoup.Achievement.SeoSleazeballTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.SeoSleazeball

  test "earns achievement when page has all three SEO elements" do
    html = """
    <html>
      <head>
        <title>SEO Optimized Page</title>
        <meta name="description" content="This is a description of the page content for search engines.">
        <meta property="og:title" content="Open Graph Title">
        <meta property="og:description" content="Description for social media sharing">
        <meta property="og:image" content="https://example.com/image.jpg">
        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:title" content="Twitter Card Title">
        <meta name="twitter:description" content="Description for Twitter">
      </head>
      <body>
        <h1>SEO Optimized Page</h1>
        <p>This page has all the SEO meta tags.</p>
      </body>
    </html>
    """

    assert_achievement_earned(SeoSleazeball, html)
  end

  test "doesn't earn achievement when missing Open Graph tags" do
    html = """
    <html>
      <head>
        <title>Partially SEO Optimized</title>
        <meta name="description" content="This is a description of the page content.">
        <meta name="twitter:card" content="summary">
        <meta name="twitter:title" content="Twitter Card Title">
      </head>
      <body>
        <h1>Partially SEO Optimized</h1>
        <p>This page is missing Open Graph tags.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(SeoSleazeball, html)
  end

  test "doesn't earn achievement when missing Twitter Card tags" do
    html = """
    <html>
      <head>
        <title>Partially SEO Optimized</title>
        <meta name="description" content="This is a description of the page content.">
        <meta property="og:title" content="Open Graph Title">
        <meta property="og:description" content="Description for social media">
      </head>
      <body>
        <h1>Partially SEO Optimized</h1>
        <p>This page is missing Twitter Card tags.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(SeoSleazeball, html)
  end

  test "doesn't earn achievement when missing meta description" do
    html = """
    <html>
      <head>
        <title>Partially SEO Optimized</title>
        <meta property="og:title" content="Open Graph Title">
        <meta property="og:image" content="https://example.com/image.jpg">
        <meta name="twitter:card" content="summary">
        <meta name="twitter:title" content="Twitter Card Title">
      </head>
      <body>
        <h1>Partially SEO Optimized</h1>
        <p>This page is missing meta description.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(SeoSleazeball, html)
  end

  test "doesn't earn achievement with no SEO tags at all" do
    html = """
    <html>
      <head>
        <title>Simple Page</title>
      </head>
      <body>
        <h1>No SEO Tags</h1>
        <p>This page has no SEO optimization.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(SeoSleazeball, html)
  end
end