defmodule Divsoup.Achievement.DataDrivenTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.DataDriven

  test "earns achievement when more than 8 elements have data-* attributes" do
    html = """
    <html>
      <head>
        <title>Data Driven Test</title>
      </head>
      <body>
        <div data-id="1" data-role="container">Main container</div>
        <div data-section="intro">Introduction</div>
        <button data-action="submit" data-target="form">Submit</button>
        <span data-highlight="true">Important text</span>
        <p data-content="description">Description paragraph</p>
        <a href="#" data-link="internal" data-page="home">Home</a>
        <input type="text" data-validation="required" data-type="text">
        <select data-options="dynamic" data-source="api">
          <option value="1">Option 1</option>
        </select>
        <img src="image.jpg" data-src="high-res.jpg" data-lazy="true">
        <ul data-list-type="bullet">
          <li data-item="1">Item 1</li>
        </ul>
      </body>
    </html>
    """

    assert_achievement_earned(DataDriven, html)
  end

  test "doesn't earn achievement when 8 or fewer elements have data-* attributes" do
    html = """
    <html>
      <head>
        <title>Data Driven Test</title>
      </head>
      <body>
        <div data-id="1">Item 1</div>
        <div data-id="2">Item 2</div>
        <div data-id="3">Item 3</div>
        <div data-id="4">Item 4</div>
        <div data-id="5">Item 5</div>
        <div data-id="6">Item 6</div>
        <div data-id="7">Item 7</div>
        <div data-id="8">Item 8</div>
        <div>No data attribute</div>
      </body>
    </html>
    """

    assert_achievement_not_earned(DataDriven, html)
  end
end