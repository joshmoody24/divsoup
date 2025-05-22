defmodule Divsoup.Achievement.ImpaTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.Impa

  test "earns achievement when page uses attachShadow" do
    html = """
    <html>
      <head>
        <title>Shadow DOM with JS</title>
      </head>
      <body>
        <div id="shadow-host"></div>
        <script>
          const host = document.getElementById('shadow-host');
          const shadowRoot = host.attachShadow({mode: 'open'});
          shadowRoot.innerHTML = '<h2>This is shadow content</h2>';
        </script>
      </body>
    </html>
    """

    assert_achievement_earned(Impa, html)
  end

  test "earns achievement when page uses declarative shadowroot" do
    html = """
    <html>
      <head>
        <title>Declarative Shadow DOM</title>
      </head>
      <body>
        <host-element>
          <template shadowroot="open">
            <style>
              p { color: blue; }
            </style>
            <p>This content is in the shadow root</p>
          </template>
          <p>This content is in the light DOM</p>
        </host-element>
      </body>
    </html>
    """

    assert_achievement_earned(Impa, html)
  end

  test "earns achievement with closed shadow root" do
    html = """
    <html>
      <head>
        <title>Closed Shadow Root</title>
      </head>
      <body>
        <custom-element>
          <template shadowroot="closed">
            <slot></slot>
          </template>
          <p>This content gets projected through the slot</p>
        </custom-element>
      </body>
    </html>
    """

    assert_achievement_earned(Impa, html)
  end

  test "doesn't earn achievement without shadow DOM" do
    html = """
    <html>
      <head>
        <title>Regular DOM</title>
      </head>
      <body>
        <div>
          <p>This page doesn't use shadow DOM</p>
          <template>
            <p>This is just a regular template, not shadow DOM</p>
          </template>
        </div>
        <script>
          // No shadow DOM API calls here
          document.querySelector('div').innerHTML += '<p>Added content</p>';
        </script>
      </body>
    </html>
    """

    assert_achievement_not_earned(Impa, html)
  end
end