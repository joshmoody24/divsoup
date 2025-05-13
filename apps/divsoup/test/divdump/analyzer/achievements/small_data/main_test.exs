defmodule Divsoup.Achievement.SmallDataTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.SmallData

  test "earns achievement with JSON-LD" do
    html = """
    <html>
      <head>
        <title>Small Data Test</title>
        <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "Person",
          "name": "John Doe",
          "jobTitle": "Software Developer",
          "url": "https://example.com"
        }
        </script>
      </head>
      <body>
        <h1>Small Data Example</h1>
        <p>Some content</p>
      </body>
    </html>
    """

    assert_achievement_earned(SmallData, html)
  end

  test "earns achievement with Microdata" do
    html = """
    <html>
      <head>
        <title>Small Data Test</title>
      </head>
      <body>
        <h1>Small Data Example</h1>
        <div itemscope itemtype="https://schema.org/Person">
          <span itemprop="name">John Doe</span>
          <span itemprop="jobTitle">Software Developer</span>
          <a href="https://example.com" itemprop="url">Website</a>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(SmallData, html)
  end

  test "doesn't earn achievement without structured data" do
    html = """
    <html>
      <head>
        <title>Small Data Test</title>
        <script>
          // Regular JavaScript, not JSON-LD
          console.log("Hello, world!");
        </script>
      </head>
      <body>
        <h1>Small Data Example</h1>
        <div>
          <span>John Doe</span>
          <span>Software Developer</span>
          <a href="https://example.com">Website</a>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(SmallData, html)
  end
end