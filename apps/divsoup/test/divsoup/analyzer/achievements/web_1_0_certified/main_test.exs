defmodule Divsoup.Achievement.Web10CertifiedTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.Web10Certified

  test "earns achievement with HTML 3.2 Final DOCTYPE" do
    html = """
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
    <html>
      <head>
        <title>HTML 3.2 Page</title>
      </head>
      <body>
        <p>This is an HTML 3.2 certified page!</p>
      </body>
    </html>
    """

    assert_achievement_earned(Web10Certified, html)
  end

  test "earns achievement with simple HTML 3.2 DOCTYPE" do
    html = """
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
    <html>
      <head>
        <title>HTML 3.2 Page (Simple Version)</title>
      </head>
      <body>
        <p>This is an HTML 3.2 certified page (simple version)!</p>
      </body>
    </html>
    """

    assert_achievement_earned(Web10Certified, html)
  end

  test "earns achievement with HTML 3.2 DOCTYPE with extra spacing" do
    html = """
    <!DOCTYPE HTML PUBLIC  "-//W3C//DTD  HTML  3.2  Final//EN"  >
    <html>
      <head>
        <title>HTML 3.2 Page with Extra Spacing</title>
      </head>
      <body>
        <p>This is an HTML 3.2 certified page with extra spacing in the DOCTYPE!</p>
      </body>
    </html>
    """

    assert_achievement_earned(Web10Certified, html)
  end

  test "doesn't earn achievement with HTML5 DOCTYPE" do
    html = """
    <!DOCTYPE html>
    <html>
      <head>
        <title>HTML5 Page</title>
      </head>
      <body>
        <p>This is an HTML5 page!</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(Web10Certified, html)
  end

  test "doesn't earn achievement with HTML 4.01 DOCTYPE" do
    html = """
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    <html>
      <head>
        <title>HTML 4.01 Page</title>
      </head>
      <body>
        <p>This is an HTML 4.01 page!</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(Web10Certified, html)
  end

  test "doesn't earn achievement with no DOCTYPE" do
    html = """
    <html>
      <head>
        <title>No DOCTYPE Page</title>
      </head>
      <body>
        <p>This page has no DOCTYPE declaration!</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(Web10Certified, html)
  end
end

