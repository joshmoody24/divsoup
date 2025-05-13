defmodule Divsoup.Achievement.CrossPlatformTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.CrossPlatform

  test "earns achievement when page has no vendor-prefixed CSS" do
    html = """
    <html>
      <head>
        <style>
          body {
            font-family: Arial, sans-serif;
            color: #333;
          }
          .container {
            display: flex;
            flex-direction: column;
          }
        </style>
      </head>
      <body>
        <div class="container" style="padding: 20px; margin: 10px;">
          <h1>Standard CSS</h1>
          <p>This page uses standard CSS properties only.</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(CrossPlatform, html)
  end

  test "doesn't earn achievement with -webkit- prefixed CSS" do
    html = """
    <html>
      <head>
        <style>
          .box {
            -webkit-border-radius: 10px;
            border-radius: 10px;
          }
        </style>
      </head>
      <body>
        <div class="box">
          <h1>Webkit Prefixes</h1>
          <p>This page uses webkit-prefixed CSS.</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(CrossPlatform, html)
  end

  test "doesn't earn achievement with -moz- prefixed CSS" do
    html = """
    <html>
      <head>
        <style>
          .custom-select {
            -moz-appearance: none;
            appearance: none;
          }
        </style>
      </head>
      <body>
        <select class="custom-select">
          <option>Option 1</option>
          <option>Option 2</option>
        </select>
      </body>
    </html>
    """

    assert_achievement_not_earned(CrossPlatform, html)
  end

  test "doesn't earn achievement with multiple vendor prefixes" do
    html = """
    <html>
      <head>
        <style>
          .gradient {
            background: linear-gradient(to right, #f00, #00f);
            -webkit-background-clip: text;
            -moz-background-clip: text;
            background-clip: text;
          }
        </style>
      </head>
      <body>
        <h1 class="gradient">Multiple Prefixes</h1>
        <div style="-ms-grid-column: 1; -o-transition: all 0.3s ease;">
          Content with inline vendor prefixes
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(CrossPlatform, html)
  end
end