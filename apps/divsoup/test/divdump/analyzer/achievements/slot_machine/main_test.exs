defmodule Divsoup.Achievement.SlotMachineTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.SlotMachine

  test "earns achievement when page has template with three consecutive slot elements" do
    html = """
    <html>
      <head>
        <title>Slot Machine</title>
      </head>
      <body>
        <template id="triple-slot-template">
          <div class="container">
            <slot name="header"></slot>
            <slot name="content"></slot>
            <slot name="footer"></slot>
          </div>
        </template>

        <my-component>
          <h2 slot="header">Header Content</h2>
          <p slot="content">Main content goes here</p>
          <div slot="footer">Footer content</div>
        </my-component>
      </body>
    </html>
    """

    assert_achievement_earned(SlotMachine, html)
  end

  test "earns achievement with three slots as direct children of template" do
    html = """
    <html>
      <body>
        <template>
          <slot></slot>
          <slot></slot>
          <slot></slot>
        </template>
      </body>
    </html>
    """

    assert_achievement_earned(SlotMachine, html)
  end

  test "doesn't earn achievement when template has fewer than three slots" do
    html = """
    <html>
      <body>
        <template id="two-slot-template">
          <div>
            <slot name="header"></slot>
            <slot name="content"></slot>
          </div>
        </template>
      </body>
    </html>
    """

    assert_achievement_not_earned(SlotMachine, html)
  end

  test "doesn't earn achievement when three slots are not consecutive" do
    html = """
    <html>
      <body>
        <template id="interrupted-slots">
          <slot name="first"></slot>
          <div>Some separator content</div>
          <slot name="second"></slot>
          <slot name="third"></slot>
        </template>
      </body>
    </html>
    """

    assert_achievement_not_earned(SlotMachine, html)
  end

  test "doesn't earn achievement without template element" do
    html = """
    <html>
      <body>
        <div id="not-a-template">
          <slot></slot>
          <slot></slot>
          <slot></slot>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(SlotMachine, html)
  end
end