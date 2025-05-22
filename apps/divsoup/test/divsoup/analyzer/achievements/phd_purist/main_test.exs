defmodule Divsoup.Achievement.PhDPuristTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.PhDPurist

  test "earns achievement with complex math element having multiple children" do
    html = """
    <html>
      <head>
        <title>MathML Test</title>
      </head>
      <body>
        <p>The quadratic formula is:</p>
        <math>
          <mi>x</mi>
          <mo>=</mo>
          <mfrac>
            <mrow>
              <mo>−</mo>
              <mi>b</mi>
              <mo>±</mo>
              <msqrt>
                <msup>
                  <mi>b</mi>
                  <mn>2</mn>
                </msup>
                <mo>−</mo>
                <mn>4</mn>
                <mi>a</mi>
                <mi>c</mi>
              </msqrt>
            </mrow>
            <mrow>
              <mn>2</mn>
              <mi>a</mi>
            </mrow>
          </mfrac>
        </math>
      </body>
    </html>
    """

    assert_achievement_earned(PhDPurist, html)
  end

  test "earns achievement with math element containing complex components" do
    html = """
    <html>
      <head>
        <title>MathML Test</title>
      </head>
      <body>
        <p>A matrix:</p>
        <math>
          <mtable>
            <mtr>
              <mtd><mn>1</mn></mtd>
              <mtd><mn>0</mn></mtd>
            </mtr>
            <mtr>
              <mtd><mn>0</mn></mtd>
              <mtd><mn>1</mn></mtd>
            </mtr>
          </mtable>
        </math>
      </body>
    </html>
    """

    assert_achievement_earned(PhDPurist, html)
  end

  test "doesn't earn achievement with trivial math element" do
    html = """
    <html>
      <head>
        <title>MathML Test</title>
      </head>
      <body>
        <p>A simple expression:</p>
        <math>
          <mn>2</mn>
          <mo>+</mo>
          <mn>2</mn>
        </math>
      </body>
    </html>
    """

    assert_achievement_not_earned(PhDPurist, html)
  end

  test "doesn't earn achievement without math element" do
    html = """
    <html>
      <head>
        <title>No MathML</title>
      </head>
      <body>
        <p>Just regular text and no math elements.</p>
      </body>
    </html>
    """

    assert_achievement_not_earned(PhDPurist, html)
  end
end