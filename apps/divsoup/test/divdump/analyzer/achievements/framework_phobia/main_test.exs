defmodule Divsoup.Achievement.FrameworkPhobiaTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.FrameworkPhobia

  test "earns achievement when page has custom element and no frameworks" do
    html = """
    <html>
      <body>
        <h1>Web Components</h1>
        <p>This page uses custom elements without a JavaScript framework.</p>
        <my-custom-element>
          <p>Content inside a custom element</p>
        </my-custom-element>
        <user-profile username="johndoe" avatar="/images/johndoe.jpg"></user-profile>
      </body>
    </html>
    """

    assert_achievement_earned(FrameworkPhobia, html)
  end

  test "doesn't earn achievement without custom elements" do
    html = """
    <html>
      <body>
        <h1>Regular HTML</h1>
        <p>This page has no custom elements.</p>
        <div class="component">
          <p>This is just a regular div, not a custom element.</p>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(FrameworkPhobia, html)
  end

  test "doesn't earn achievement with React framework" do
    html = """
    <html>
      <head>
        <script src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
      </head>
      <body>
        <h1>React App</h1>
        <my-component>Using custom elements with React</my-component>
        <div data-reactroot id="root"></div>
      </body>
    </html>
    """

    assert_achievement_not_earned(FrameworkPhobia, html)
  end

  test "doesn't earn achievement with Vue framework" do
    html = """
    <html>
      <body>
        <h1>Vue App</h1>
        <div v-if="showComponent">
          <custom-card v-for="item in items" :key="item.id">
            {{item.name}}
          </custom-card>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(FrameworkPhobia, html)
  end

  test "doesn't earn achievement with Angular framework" do
    html = """
    <html>
      <body ng-app="myApp">
        <h1>Angular App</h1>
        <div ng-controller="MainController">
          <user-card ng-repeat="user in users"></user-card>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(FrameworkPhobia, html)
  end
end