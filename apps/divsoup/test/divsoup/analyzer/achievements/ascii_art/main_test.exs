defmodule Divsoup.Achievement.AsciiArtTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.AsciiArt

  test "earns achievement with ASCII art in HTML comment" do
    html = """
    <html>
      <head>
        <title>ASCII Art Test</title>
      </head>
      <body>
        <h1>ASCII Art Example</h1>
        <!-- 
          +---------+
          |  ASCII  |
          |   Art   |
          |  Rules! |
          +---------+
        -->
        <p>Some visible content</p>
      </body>
    </html>
    """

    assert_achievement_earned(AsciiArt, html)
  end

  test "earns achievement with more complex ASCII art" do
    html = """
    <html>
      <head>
        <title>ASCII Art Test</title>
      </head>
      <body>
        <h1>ASCII Art Example</h1>
        <!-- 
             /\\_/\\
            ( o.o )
             > ^ <
             |   |
             /---\\
           /       \\
          |         |
        -->
        <p>Some visible content</p>
      </body>
    </html>
    """

    assert_achievement_earned(AsciiArt, html)
  end

  test "earns achievement with another ASCII art example" do
    html = """
    <html>
      <head>
        <title>ASCII Art Test</title>
      </head>
      <body>
        <!-- 
            _______
           /       \\
          |         |
          |_________|
              | |
              | |
              | |
        -->
        <p>Some content</p>
      </body>
    </html>
    """

    assert_achievement_earned(AsciiArt, html)
  end

  # From https://hasthelargehadroncolliderdestroyedtheworldyet.com/
  test "earns achievement with a real-world ASCII art example" do
    html = """
    <html>
      <head>
        <title>ASCII Art Test</title>
      </head>
      <body>

    <!-- if the lhc actually destroys the earth & this page isn't yet updated
    please email redacted@redacted.com to receive a full refund

                         ___
                        / / \\\                   Has the great lazer eyed bunny
                        \ \  \\\                      destroyed the world yet?
                         \ \  \\\                                                               _______
           ______________ \ \  \\\__                                                           /        \
    ____  _/                       (O)\---------------------------------------------           /          \
    /    \/                         ( __|                                                      |            |
    |____/               |      ------- \\              status: Getting Closer                  \          /
         |______________/_______________//              [89%/100%]    eta: ..Soon                \________/


    check out our exciting new social media presence at http://redacted.com
    -->
        <p>Some content</p>
      </body>
    </html>
    """

    assert_achievement_earned(AsciiArt, html)
  end

  test "doesn't earn achievement with regular comments" do
    html = """
    <html>
      <head>
        <title>ASCII Art Test</title>
        <!-- This is a regular comment -->
      </head>
      <body>
        <h1>ASCII Art Example</h1>
        <!-- 
          This is a multi-line comment
          but it doesn't contain any ASCII art
          just regular text
        -->
        <p>Some visible content</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(AsciiArt, html)
  end

  test "commented-out code does not count as ASCII art" do
    html = """
    <html>
      <head>
        <title>ASCII Art Test</title>
        <!-- This is a regular comment -->
      </head>
      <body>
        <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->
      </body>
    </html>
    """

    assert_achievement_not_earned(AsciiArt, html)
  end

  test "commented-out code does not count as ASCII art (harder version)" do
    html = """
    <html>
      <head>
        <title>ASCII Art Test</title>
        <!-- This is a regular comment -->
      </head>
      <body>
        <!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
        <!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
        <!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
        <!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
      </body>
    </html>
    """

    assert_achievement_not_earned(AsciiArt, html)
  end
end
