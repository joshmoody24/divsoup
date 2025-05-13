defmodule Divsoup.Achievement.BigheadedTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.Bigheaded

  test "earns achievement with 25 or more elements in head" do
    # Generate a head with 25 metadata elements
    meta_tags = Enum.map_join(1..15, "\n    ", fn i -> 
      "<meta name=\"meta#{i}\" content=\"value#{i}\">"
    end)
    
    link_tags = Enum.map_join(1..10, "\n    ", fn i -> 
      "<link rel=\"stylesheet\" href=\"style#{i}.css\">"
    end)

    html = """
    <html>
      <head>
        <title>Bigheaded Test</title>
        #{meta_tags}
        #{link_tags}
      </head>
      <body>
        <h1>Bigheaded Example</h1>
        <p>Some content</p>
      </body>
    </html>
    """

    assert_achievement_earned(Bigheaded, html)
  end

  test "doesn't earn achievement with fewer than 25 elements in head" do
    # Generate a head with 20 metadata elements
    meta_tags = Enum.map_join(1..10, "\n    ", fn i -> 
      "<meta name=\"meta#{i}\" content=\"value#{i}\">"
    end)
    
    link_tags = Enum.map_join(1..9, "\n    ", fn i -> 
      "<link rel=\"stylesheet\" href=\"style#{i}.css\">"
    end)

    html = """
    <html>
      <head>
        <title>Bigheaded Test</title>
        #{meta_tags}
        #{link_tags}
      </head>
      <body>
        <h1>Bigheaded Example</h1>
        <p>Some content</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(Bigheaded, html)
  end
end