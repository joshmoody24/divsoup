defmodule Divsoup.Achievement.ProgressiveTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.Progressive

  test "earns achievement with both progress and meter elements" do
    html = """
    <html>
      <head>
        <title>Progressive Test</title>
      </head>
      <body>
        <div>
          <h2>Download Progress</h2>
          <progress id="download" value="70" max="100">70%</progress>
          
          <h2>Disk Usage</h2>
          <meter id="disk" value="0.75" min="0" max="1" low="0.3" high="0.8" optimum="0.5">75%</meter>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(Progressive, html)
  end

  test "earns achievement with multiple progress and meter elements" do
    html = """
    <html>
      <head>
        <title>Multiple Progressive Elements</title>
      </head>
      <body>
        <div>
          <h2>Download Progress</h2>
          <progress id="download1" value="70" max="100">70%</progress>
          <progress id="download2" value="30" max="100">30%</progress>
          
          <h2>Disk Usage</h2>
          <meter id="disk1" value="0.75" min="0" max="1">75%</meter>
          <meter id="disk2" value="0.50" min="0" max="1">50%</meter>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(Progressive, html)
  end

  test "doesn't earn achievement with only progress element" do
    html = """
    <html>
      <head>
        <title>Only Progress Element</title>
      </head>
      <body>
        <div>
          <h2>Download Progress</h2>
          <progress id="download" value="70" max="100">70%</progress>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(Progressive, html)
  end

  test "doesn't earn achievement with only meter element" do
    html = """
    <html>
      <head>
        <title>Only Meter Element</title>
      </head>
      <body>
        <div>
          <h2>Disk Usage</h2>
          <meter id="disk" value="0.75" min="0" max="1">75%</meter>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(Progressive, html)
  end

  test "doesn't earn achievement without any progress or meter elements" do
    html = """
    <html>
      <head>
        <title>No Progressive Elements</title>
      </head>
      <body>
        <div>
          <p>This page has no progress or meter elements.</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(Progressive, html)
  end
end