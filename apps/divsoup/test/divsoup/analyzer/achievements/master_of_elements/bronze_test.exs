defmodule Divsoup.Achievement.MasterOfElements.BronzeTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.MasterOfElements.Bronze
  alias Divsoup.Util.Html

  test "earns achievement with exactly 17 different valid elements" do
    # Get 17 standard elements from the HTML util for a positive test
    standard_elements = Html.standard_elements()
    |> Enum.take_random(17)
    
    # Create HTML with exactly these 17 elements
    element_tags = standard_elements
    |> Enum.map(fn elem -> "<#{elem}></#{elem}>" end)
    |> Enum.join("\n      ")
    
    html = """
    <html>
      <head>
        <title>Bronze Elements Test</title>
      </head>
      <body>
        <div id="container">
          #{element_tags}
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(Bronze, html)
  end

  test "doesn't earn achievement with too few elements" do
    html = """
    <html>
      <head>
        <title>Simple Page</title>
      </head>
      <body>
        <h1>Header</h1>
        <p>Paragraph text</p>
        <div>A div</div>
        <span>A span</span>
      </body>
    </html>
    """

    assert_achievement_not_earned(Bronze, html)
  end
  
  test "doesn't count invalid elements" do
    html = """
    <html>
      <head>
        <title>Invalid Elements Test</title>
      </head>
      <body>
        <h1>Header</h1>
        <p>Paragraph text</p>
        <div>A div</div>
        <span>A span</span>
        <custom-element>Custom element</custom-element>
        <another-custom>Another custom</another-custom>
        <foo>Foo</foo>
        <bar>Bar</bar>
        <baz>Baz</baz>
        <qux>Qux</qux>
        <corge>Corge</corge>
        <grault>Grault</grault>
        <garply>Garply</garply>
        <waldo>Waldo</waldo>
        <fred>Fred</fred>
        <plugh>Plugh</plugh>
        <xyzzy>Xyzzy</xyzzy>
        <thud>Thud</thud>
      </body>
    </html>
    """

    assert_achievement_not_earned(Bronze, html)
  end
end