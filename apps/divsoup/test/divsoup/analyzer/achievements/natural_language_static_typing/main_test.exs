defmodule Divsoup.Achievement.NaturalLanguageStaticTypingTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.NaturalLanguageStaticTyping

  test "earns achievement when there's an input with spellcheck=\"true\"" do
    html = """
    <html>
      <head>
        <title>Spellcheck Test</title>
      </head>
      <body>
        <form>
          <input type="text" name="name" spellcheck="false">
          <input type="text" name="description" spellcheck="true">
          <input type="number" name="age">
          <button type="submit">Submit</button>
        </form>
      </body>
    </html>
    """

    assert_achievement_earned(NaturalLanguageStaticTyping, html)
  end

  test "earns achievement when there's a textarea with spellcheck=\"true\"" do
    html = """
    <html>
      <head>
        <title>Spellcheck Test</title>
      </head>
      <body>
        <form>
          <textarea name="comments" spellcheck="true"></textarea>
          <button type="submit">Submit</button>
        </form>
      </body>
    </html>
    """

    assert_achievement_earned(NaturalLanguageStaticTyping, html)
  end

  test "doesn't earn achievement without spellcheck=\"true\" on inputs or textareas" do
    html = """
    <html>
      <head>
        <title>Spellcheck Test</title>
      </head>
      <body>
        <form>
          <input type="text" name="name">
          <input type="text" name="description" spellcheck="false">
          <textarea name="comments"></textarea>
          <textarea name="notes" spellcheck="false"></textarea>
          <button type="submit">Submit</button>
        </form>
      </body>
    </html>
    """

    assert_achievement_not_earned(NaturalLanguageStaticTyping, html)
  end
end