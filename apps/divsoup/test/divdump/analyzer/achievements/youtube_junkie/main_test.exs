defmodule Divsoup.Achievement.YoutubeJunkieTest do
  use ExUnit.Case
  import Divsoup.AchievementTest.Helper

  alias Divsoup.Achievement.YoutubeJunkie

  test "earns achievement with 3 YouTube iframe embeds" do
    html = """
    <html>
      <head>
        <title>YouTube Junkie Test</title>
      </head>
      <body>
        <div>
          <h2>Video 1</h2>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
          
          <h2>Video 2</h2>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/xvFZjo5PgG0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
          
          <h2>Video 3</h2>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/kJQP7kiw5Fk" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(YoutubeJunkie, html)
  end

  test "earns achievement with mixed YouTube embed types" do
    html = """
    <html>
      <head>
        <title>Mixed YouTube Embeds</title>
      </head>
      <body>
        <div>
          <h2>Iframe Embed</h2>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>
          
          <h2>Object Embed</h2>
          <object width="560" height="315" data="https://www.youtube.com/embed/xvFZjo5PgG0"></object>
          
          <h2>Embed Tag</h2>
          <embed width="560" height="315" src="https://www.youtube.com/embed/kJQP7kiw5Fk">
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(YoutubeJunkie, html)
  end

  test "earns achievement with old-style YouTube embeds" do
    html = """
    <html>
      <head>
        <title>Old-style YouTube Embeds</title>
      </head>
      <body>
        <div>
          <h2>Old Embed 1</h2>
          <object width="425" height="344">
            <param name="movie" value="https://www.youtube.com/v/dQw4w9WgXcQ"></param>
            <param name="allowFullScreen" value="true"></param>
            <param name="allowScriptAccess" value="always"></param>
            <embed src="https://www.youtube.com/v/dQw4w9WgXcQ" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="425" height="344"></embed>
          </object>
          
          <h2>Old Embed 2</h2>
          <object width="425" height="344">
            <param name="movie" value="https://www.youtube.com/v/xvFZjo5PgG0"></param>
            <param name="allowFullScreen" value="true"></param>
            <param name="allowScriptAccess" value="always"></param>
            <embed src="https://www.youtube.com/v/xvFZjo5PgG0" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="425" height="344"></embed>
          </object>
          
          <h2>Old Embed 3</h2>
          <object width="425" height="344">
            <param name="movie" value="https://www.youtube.com/v/kJQP7kiw5Fk"></param>
            <param name="allowFullScreen" value="true"></param>
            <param name="allowScriptAccess" value="always"></param>
            <embed src="https://www.youtube.com/v/kJQP7kiw5Fk" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="425" height="344"></embed>
          </object>
        </div>
      </body>
    </html>
    """

    assert_achievement_earned(YoutubeJunkie, html)
  end

  test "doesn't earn achievement with fewer than 3 YouTube embeds" do
    html = """
    <html>
      <head>
        <title>Not Enough YouTube Embeds</title>
      </head>
      <body>
        <div>
          <h2>Video 1</h2>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>
          
          <h2>Video 2</h2>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/xvFZjo5PgG0" frameborder="0" allowfullscreen></iframe>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(YoutubeJunkie, html)
  end

  test "doesn't earn achievement with non-YouTube video embeds" do
    html = """
    <html>
      <head>
        <title>Not YouTube Embeds</title>
      </head>
      <body>
        <div>
          <h2>Vimeo Video 1</h2>
          <iframe src="https://player.vimeo.com/video/123456789" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
          
          <h2>Vimeo Video 2</h2>
          <iframe src="https://player.vimeo.com/video/987654321" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
          
          <h2>Vimeo Video 3</h2>
          <iframe src="https://player.vimeo.com/video/567891234" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
        </div>
      </body>
    </html>
    """

    assert_achievement_not_earned(YoutubeJunkie, html)
  end
end