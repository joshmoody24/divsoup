defmodule Divsoup.Analyzer.SimpleScraper do
  @moduledoc """
  A simple web scraper using curl and wkhtmltopdf for development purposes.
  This avoids the complexity of browser automation for quick prototyping.
  """
  
  require Logger
  
  @doc """
  Fetches a URL and returns the HTML content, a screenshot, and basic stats.
  """
  def analyze_website(url) do
    Logger.info("Simple scraper analyzing: #{url}")
    timestamp = DateTime.utc_now()
    domain = URI.parse(url).host |> String.replace(~r/[^\w]/, "_")
    file_prefix = "#{domain}_#{:os.system_time(:seconds)}"
    
    # 1. Fetch HTML with curl
    html_path = "/home/josh/#{file_prefix}_page.html"
    html = fetch_html(url)
    File.write!(html_path, html)
    
    # 2. Take screenshot with wkhtmltopdf
    screenshot_path = "/home/josh/#{file_prefix}_screenshot.png"
    take_screenshot(url, screenshot_path)
    
    # 3. Analyze the HTML content
    element_counts = count_elements(html)
    meta_info = extract_meta_info(html)
    
    Logger.info("Saved HTML to #{html_path}")
    Logger.info("Saved screenshot to #{screenshot_path}")
    
    # 4. Return analysis results
    %{
      url: url,
      timestamp: timestamp,
      html_path: html_path,
      screenshot_path: screenshot_path,
      elements: element_counts,
      meta: meta_info
    }
  end
  
  # Helper functions
  
  defp fetch_html(url) do
    # Use curl to fetch HTML (with a 10-second timeout)
    case System.cmd("curl", ["-s", "-L", "-m", "10", url]) do
      {html, 0} -> html
      {_, _} -> "<html><body>Failed to fetch content</body></html>"
    end
  end
  
  defp take_screenshot(url, output_path) do
    # Try wkhtmltopdf first (if installed)
    wkhtmltopdf_result = System.cmd("wkhtmltopdf", ["--quiet", url, output_path], stderr_to_stdout: true)
    
    case wkhtmltopdf_result do
      {_, 0} -> 
        # Success
        :ok
      _ ->
        # If wkhtmltopdf fails, create a simple placeholder image
        Logger.warning("wkhtmltopdf failed, using placeholder image")
        # Base64 encoded 1x1 transparent pixel
        transparent_pixel = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
        File.write!(output_path, Base.decode64!(transparent_pixel))
    end
  end
  
  defp count_elements(html) do
    # Very basic element counting using regex
    element_types = ["div", "span", "p", "a", "img", "header", "footer", "main"]
    
    Enum.reduce(element_types, %{}, fn tag, acc ->
      # Count opening tags
      count = Regex.scan(~r/<#{tag}[\s>]/i, html) |> length()
      Map.put(acc, tag, count)
    end)
  end
  
  defp extract_meta_info(html) do
    # Extract basic metadata
    title = case Regex.run(~r/<title>(.*?)<\/title>/is, html) do
      [_, title] -> title
      _ -> "Unknown Title"
    end
    
    has_viewport = Regex.match?(~r/<meta[^>]*name=["']viewport["'][^>]*>/i, html)
    
    # Simple responsive check (presence of media queries)
    responsive = Regex.match?(~r/@media\s*\(/i, html)
    
    %{
      title: title,
      has_viewport: has_viewport,
      responsive: responsive,
      load_time_ms: 0 # We can't measure this with curl
    }
  end
end