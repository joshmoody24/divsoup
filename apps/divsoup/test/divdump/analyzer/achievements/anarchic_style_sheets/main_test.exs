defmodule Divsoup.Achievement.AnarchicStyleSheetsTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.AnarchicStyleSheets

  test "earns achievement with 3+ style elements in body" do
    html = """
    <html>
      <head>
        <title>Anarchic Style Sheets Test</title>
        <style>
          /* This style in head doesn't count */
          body { font-family: Arial, sans-serif; }
        </style>
      </head>
      <body>
        <div>
          <style>
            /* First body style */
            div { background-color: #f0f0f0; }
          </style>
          <p>First paragraph</p>
        </div>
        
        <style>
          /* Second body style */
          p { color: blue; }
        </style>
        
        <p>Second paragraph</p>
        
        <style>
          /* Third body style */
          a { text-decoration: none; }
        </style>
        
        <p>Third paragraph</p>
        
        <style>
          /* Fourth body style (extra) */
          h1 { font-size: 24px; }
        </style>
      </body>
    </html>
    """

    assert_achievement_earned(AnarchicStyleSheets, html)
  end

  test "doesn't earn achievement with fewer than 3 style elements in body" do
    html = """
    <html>
      <head>
        <title>Not Enough Body Styles</title>
        <style>
          /* This style in head doesn't count */
          body { font-family: Arial, sans-serif; }
        </style>
      </head>
      <body>
        <div>
          <style>
            /* First body style */
            div { background-color: #f0f0f0; }
          </style>
          <p>First paragraph</p>
        </div>
        
        <style>
          /* Second body style */
          p { color: blue; }
        </style>
        
        <p>Second paragraph</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(AnarchicStyleSheets, html)
  end

  test "doesn't earn achievement with styles only in head" do
    html = """
    <html>
      <head>
        <title>Only Head Styles</title>
        <style>
          /* First head style */
          body { font-family: Arial, sans-serif; }
        </style>
        <style>
          /* Second head style */
          div { background-color: #f0f0f0; }
        </style>
        <style>
          /* Third head style */
          p { color: blue; }
        </style>
      </head>
      <body>
        <p>This page has all styles in the head where they belong.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(AnarchicStyleSheets, html)
  end

  test "doesn't earn achievement without any styles" do
    html = """
    <html>
      <head>
        <title>No Styles</title>
      </head>
      <body>
        <p>This page has no style elements at all.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(AnarchicStyleSheets, html)
  end
end