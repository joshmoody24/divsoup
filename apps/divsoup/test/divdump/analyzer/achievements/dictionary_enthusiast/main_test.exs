defmodule Divsoup.Achievement.DictionaryEnthusiastTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.DictionaryEnthusiast

  test "earns achievement when page has dfn element" do
    html = """
    <html>
      <body>
        <h1>Definitions</h1>
        <p>A <dfn>definition</dfn> is a statement of the meaning of a term.</p>
        <p>Using proper semantic elements improves accessibility.</p>
      </body>
    </html>
    """

    assert_achievement_earned(DictionaryEnthusiast, html)
  end

  test "earns achievement when page has dl with dt and dd elements" do
    html = """
    <html>
      <body>
        <h1>Glossary</h1>
        <dl>
          <dt>HTML</dt>
          <dd>HyperText Markup Language, the standard markup language for web pages.</dd>
          
          <dt>CSS</dt>
          <dd>Cascading Style Sheets, a style sheet language used for styling web pages.</dd>
        </dl>
      </body>
    </html>
    """

    assert_achievement_earned(DictionaryEnthusiast, html)
  end

  test "earns achievement when page has both dfn and dl elements" do
    html = """
    <html>
      <body>
        <p>The term <dfn>Semantic HTML</dfn> refers to using HTML markup to reinforce the meaning of content.</p>
        
        <dl>
          <dt>Semantic</dt>
          <dd>Relating to meaning in language or logic.</dd>
          
          <dt>HTML</dt>
          <dd>HyperText Markup Language</dd>
        </dl>
      </body>
    </html>
    """

    assert_achievement_earned(DictionaryEnthusiast, html)
  end

  test "doesn't earn achievement without definition elements" do
    html = """
    <html>
      <body>
        <h1>Regular Page</h1>
        <p>This page has no definition elements.</p>
        <div>
          <h2>Terms</h2>
          <p>HTML: HyperText Markup Language</p>
          <p>CSS: Cascading Style Sheets</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(DictionaryEnthusiast, html)
  end

  test "doesn't earn achievement with dl but missing dt or dd" do
    html = """
    <html>
      <body>
        <h1>Incomplete Definition List</h1>
        <dl>
          <li>HTML</li>
          <li>CSS</li>
        </dl>
      </body>
    </html>
    """

    assert_achievement_not_earned(DictionaryEnthusiast, html)
  end
end