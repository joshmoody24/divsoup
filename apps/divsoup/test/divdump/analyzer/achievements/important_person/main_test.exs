defmodule Divsoup.Achievement.ImportantPersonTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.ImportantPerson

  test "earns achievement when !important appears 10 or more times" do
    html = """
    <html>
      <head>
        <title>!important Test</title>
        <style>
          .red { color: red !important; }
          .big { font-size: 20px !important; }
          .bold { font-weight: bold !important; }
          .center { text-align: center !important; }
          .hidden { display: none !important; }
          .visible { visibility: visible !important; }
          .block { display: block !important; }
          .margin { margin: 10px !important; }
          .padding { padding: 10px !important; }
          .border { border: 1px solid black !important; }
        </style>
      </head>
      <body>
        <div style="color: blue !important;">
          Testing !important
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(ImportantPerson, html)
  end

  test "doesn't earn achievement when !important appears less than 10 times" do
    html = """
    <html>
      <head>
        <title>!important Test</title>
        <style>
          .red { color: red !important; }
          .big { font-size: 20px !important; }
          .bold { font-weight: bold !important; }
          .center { text-align: center !important; }
          .hidden { display: none !important; }
        </style>
      </head>
      <body>
        <div style="color: blue !important;">
          Testing !important
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(ImportantPerson, html)
  end

  test "doesn't earn achievement without !important" do
    html = """
    <html>
      <head>
        <title>!important Test</title>
        <style>
          .red { color: red; }
          .big { font-size: 20px; }
          .bold { font-weight: bold; }
        </style>
      </head>
      <body>
        <div style="color: blue;">
          Testing styles without !important
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(ImportantPerson, html)
  end
end