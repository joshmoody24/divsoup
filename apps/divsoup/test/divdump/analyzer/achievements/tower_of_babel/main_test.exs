defmodule Divsoup.Achievement.TowerOfBabelTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.TowerOfBabel

  test "earns achievement when page has at least 2 different lang attributes" do
    html = """
    <html lang="en">
      <head>
        <title>Multilingual Page</title>
      </head>
      <body>
        <h1>Hello World</h1>
        <p>This is in English.</p>
        <div lang="fr">
          <p>Bonjour le monde!</p>
          <p>Ceci est en français.</p>
        </div>
        <div lang="es">
          <p>¡Hola Mundo!</p>
          <p>Esto está en español.</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(TowerOfBabel, html)
  end

  test "doesn't earn achievement when page has fewer than 2 different lang attributes" do
    html = """
    <html lang="en">
      <head>
        <title>English Only Page</title>
      </head>
      <body>
        <h1>Hello World</h1>
        <p>This is in English.</p>
        <div>
          <p>This is also in English.</p>
        </div>
        <div lang="en">
          <p>This has a lang attribute but it's the same as the html element.</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(TowerOfBabel, html)
  end

  test "doesn't earn achievement when page has no lang attributes" do
    html = """
    <html>
      <head>
        <title>No Lang Attributes</title>
      </head>
      <body>
        <h1>Hello World</h1>
        <p>This page has no lang attributes at all.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(TowerOfBabel, html)
  end
end