defmodule Divsoup.Analyzer.Browser do
  @moduledoc """
  Simple module for retrieving HTML content from a website using headless Chrome.
  """
  
  require Logger
  
  @doc """
  Captures a website's rendered HTML using Chrome's headless mode.
  
  ## Parameters
  
    * `url` - URL of the website to analyze
  
  ## Returns
  
    * `{:ok, result}` - Map containing url, timestamp, and path to saved HTML
    * `{:error, reason}` - Error message if capture fails
  """
  def analyze_website(url) do
    Logger.info("Analyzing website: #{url}")
    
    try do
      # Generate unique filename based on domain and timestamp
      timestamp = DateTime.utc_now()
      domain = url |> URI.parse() |> Map.get(:host, "unknown") |> String.replace(~r/[^\w]/, "_")
      filename = "#{domain}_#{System.system_time(:second)}.html"
      
      # Prepare directories
      output_dir = "/tmp/divsoup_analysis"
      File.mkdir_p!(output_dir)
      file_path = Path.join(output_dir, filename)
      
      # Execute Chrome in headless mode to capture rendered HTML
      chrome_cmd = build_chrome_command(url, file_path)
      Logger.debug("Chrome command: #{chrome_cmd}")
      {_, status} = System.cmd("sh", ["-c", chrome_cmd])
      
      # Generate screenshot and PDF paths
      screenshot_path = "#{Path.rootname(file_path)}_screenshot.png"
      pdf_path = "#{Path.rootname(file_path)}_pdf.pdf"
      
      # Process result
      case check_output(status, file_path, screenshot_path, pdf_path) do
        {:ok, size} ->
          Logger.info("Successfully captured HTML (#{size} bytes), screenshot, and PDF")
          {:ok, %{
            url: url, 
            timestamp: timestamp, 
            html_path: file_path,
            screenshot_path: screenshot_path,
            pdf_path: pdf_path
          }}
          
        {:error, reason} ->
          Logger.error(reason)
          {:error, reason}
      end
    rescue
      e ->
        reason = "Website analysis failed: #{Exception.message(e)}"
        Logger.error(reason)
        Logger.error(Exception.format_stacktrace(__STACKTRACE__))
        {:error, reason}
    end
  end
  
  # Build Chrome command string with appropriate options
  defp build_chrome_command(url, output_path) do
    # Extract base filename without extension
    base_path = Path.rootname(output_path)
    screenshot_path = "#{base_path}_screenshot.png"
    pdf_path = "#{base_path}_pdf.pdf"
    
    # Command to capture HTML, screenshot, and PDF
    "chromium --headless --disable-gpu --no-sandbox " <>
    "--screenshot=#{screenshot_path} " <>
    "--print-to-pdf=#{pdf_path} " <>
    "--window-size=1920,1080 " <>
    "--dump-dom #{url} > #{output_path} 2>/tmp/chrome_error.log"
  end
  
  # Check output files and return appropriate result
  defp check_output(0, html_path, screenshot_path, pdf_path) do
    cond do
      not File.exists?(html_path) ->
        {:error, "HTML file was not created"}
        
      File.stat!(html_path).size == 0 ->
        error_log = File.read!("/tmp/chrome_error.log")
        {:error, "HTML file is empty. Chrome error: #{String.slice(error_log, 0, 200)}..."}
        
      not File.exists?(screenshot_path) ->
        {:error, "Screenshot was not created"}
        
      File.stat!(screenshot_path).size == 0 ->
        {:error, "Screenshot file is empty"}
        
      not File.exists?(pdf_path) ->
        {:error, "PDF file was not created"}
        
      File.stat!(pdf_path).size == 0 ->
        {:error, "PDF file is empty"}
        
      true ->
        {:ok, File.stat!(html_path).size}
    end
  end
  
  defp check_output(status, _, _, _) do
    {:error, "Chrome execution failed with status #{status}"}
  end
end