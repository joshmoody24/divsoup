defmodule Divsoup.Achievement.FormFanaticTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.FormFanatic

  test "earns achievement with form containing 5+ different input types" do
    html = """
    <html>
      <head>
        <title>Form Fanatic Test</title>
      </head>
      <body>
        <form action="/submit" method="post">
          <input type="text" name="name" placeholder="Name">
          <input type="email" name="email" placeholder="Email">
          <input type="password" name="password" placeholder="Password">
          <input type="number" name="age" placeholder="Age">
          <input type="checkbox" name="subscribe" value="yes">
          <input type="radio" name="gender" value="male">
          <input type="radio" name="gender" value="female">
          <textarea name="comments"></textarea>
          <select name="country">
            <option value="us">United States</option>
            <option value="ca">Canada</option>
          </select>
          <input type="submit" value="Submit">
        </form>
      </body>
    </html>
    """

    assert_achievement_earned(FormFanatic, html)
  end

  test "earns achievement with multiple forms containing 5+ different input types combined" do
    html = """
    <html>
      <head>
        <title>Multiple Forms Test</title>
      </head>
      <body>
        <form action="/login" method="post">
          <input type="text" name="username" placeholder="Username">
          <input type="password" name="password" placeholder="Password">
          <input type="checkbox" name="remember" value="yes">
          <input type="submit" value="Login">
        </form>
        
        <form action="/register" method="post">
          <input type="email" name="email" placeholder="Email">
          <input type="date" name="birthdate">
          <select name="role">
            <option value="user">User</option>
            <option value="admin">Admin</option>
          </select>
          <input type="submit" value="Register">
        </form>
      </body>
    </html>
    """

    assert_achievement_earned(FormFanatic, html)
  end

  test "doesn't earn achievement with form containing fewer than 5 different input types" do
    html = """
    <html>
      <head>
        <title>Limited Form Test</title>
      </head>
      <body>
        <form action="/contact" method="post">
          <input type="text" name="name" placeholder="Name">
          <input type="email" name="email" placeholder="Email">
          <textarea name="message"></textarea>
          <input type="submit" value="Send">
        </form>
      </body>
    </html>
    """

    assert_achievement_not_earned(FormFanatic, html)
  end

  test "doesn't earn achievement without any forms" do
    html = """
    <html>
      <head>
        <title>No Form Test</title>
      </head>
      <body>
        <div>
          <p>This page has no forms at all.</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(FormFanatic, html)
  end
end