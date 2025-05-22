defmodule Divsoup.Achievement.YoutubeJunkie do
  alias Divsoup.Achievement

  @behaviour Divsoup.AchievementRule
  
  # Required number of YouTube embeds
  @required_embeds 3

  @impl true
  def evaluate(html_tree, raw_html) do
    # Check for iframe embeds with YouTube URLs
    youtube_iframes = Floki.find(html_tree, "iframe[src*='youtube.com'], iframe[src*='youtu.be']")
    
    # Also check for object and embed elements
    youtube_objects = Floki.find(html_tree, "object[data*='youtube.com'], object[data*='youtu.be']")
    youtube_embeds = Floki.find(html_tree, "embed[src*='youtube.com'], embed[src*='youtu.be']")
    
    # Count total YouTube embeds
    total_embeds = length(youtube_iframes) + length(youtube_objects) + length(youtube_embeds)
    
    # Check if we also need to count video tags with YouTube sources
    youtube_videos = if total_embeds < @required_embeds do
      # Check for video elements with YouTube source
      video_elements = Floki.find(html_tree, "video")
      youtube_videos = Enum.filter(video_elements, fn video ->
        sources = Floki.find(video, "source")
        Enum.any?(sources, fn source ->
          {_, attrs, _} = source
          attrs_map = Enum.into(attrs, %{})
          src = Map.get(attrs_map, "src", "")
          String.contains?(src, "youtube.com") || String.contains?(src, "youtu.be")
        end)
      end)
      
      length(youtube_videos)
    else
      0
    end
    
    # Check for old-style embed using regex on the raw HTML
    old_embed_count = if total_embeds + youtube_videos < @required_embeds do
      old_embeds = Regex.scan(~r/<param\s+name=["']movie["']\s+value=["'](?:[^"']*?youtu(?:\.be|be\.com)[^"']*?)["']/i, raw_html)
      length(old_embeds)
    else
      0
    end
    
    # Update total embeds count
    total_embeds = total_embeds + youtube_videos + old_embed_count
    
    if total_embeds >= @required_embeds do
      []
    else
      ["Page only has #{total_embeds} YouTube embeds, needs at least #{@required_embeds}"]
    end
  end

  @impl true
  def achievement do
    %Achievement{
      hierarchy: nil,
      title: "YouTube Junkie",
      group: "youtube_junkie",
      description: "Page embeds <strong>#{@required_embeds}</strong> or more <a href=\"https://youtube.com\" target=\"_blank\">YouTube</a> videos"
    }
  end
end