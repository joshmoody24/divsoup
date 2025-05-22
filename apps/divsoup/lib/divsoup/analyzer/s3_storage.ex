defmodule Divsoup.Analyzer.S3Storage do
  @moduledoc """
  Module for storing analysis results in S3.
  """

  require Logger

  @doc """
  Uploads analysis files to S3 and optionally deletes local files after upload.

  ## Parameters

    * `html_path` - Path to the HTML file
    * `screenshot_path` - Path to the screenshot file
    * `pdf_path` - Path to the PDF file
    * `url` - The URL that was analyzed
    * `timestamp` - Timestamp of the analysis (DateTime)
    * `opts` - Options:
      * `:bucket` - S3 bucket name (defaults to env var S3_BUCKET or "divsoup")
      * `:delete_after_upload` - Whether to delete local files after upload (defaults to true)

  ## Returns

    * `{:ok, result}` - Map with S3 URLs on success
    * `{:error, reason}` - Error reason on failure
  """
  def upload_analysis_files(html_path, screenshot_path, pdf_path, url, timestamp, opts \\ []) do
    bucket = Keyword.get(opts, :bucket, System.get_env("S3_BUCKET", "divsoup"))
    delete_after_upload = Keyword.get(opts, :delete_after_upload, true)

    try do
      # Configure AWS
      region = System.get_env("AWS_REGION", "us-west-1")

      # Parse the URL to get components
      parsed_url = URI.parse(url)
      
      # Extract and clean path components
      host = parsed_url.host || "unknown"
      path = parsed_url.path || "/"
      
      # Clean up the path:
      # 1. Remove trailing slash if it exists (unless the path is just "/")
      # 2. Remove leading slash to avoid double slash when combined with host
      path = cond do
        # Just the root path "/"
        path == "/" -> ""
        # Path with trailing slash
        String.ends_with?(path, "/") -> String.slice(path, 1..-2//1)
        # Normal path - remove leading slash
        true -> String.replace_prefix(path, "/", "")
      end
              
      # Combine host and path with a slash between them (unless path is empty)
      # Example: "https://joshmoody.org/blog" -> "joshmoody.org/blog"
      full_path = if path == "" do
        host  # For the root path, just use the hostname
      else
        "#{host}/#{path}"  # For other paths, add a slash between host and path
      end
      
      # Format timestamp for path
      formatted_timestamp = timestamp 
                           |> DateTime.to_string() 
                           |> String.replace(~r/[^\w]/, "-")
      
      # Create S3 keys with organized path structure including the full URL path
      html_key = "analysis/#{full_path}/#{formatted_timestamp}/page.html"
      screenshot_key = "analysis/#{full_path}/#{formatted_timestamp}/screenshot.png"
      pdf_key = "analysis/#{full_path}/#{formatted_timestamp}/page.pdf"

      # Upload files to S3
      with {:ok, html_url} <- upload_file(bucket, html_path, html_key, region),
           {:ok, screenshot_url} <- upload_file(bucket, screenshot_path, screenshot_key, region),
           {:ok, pdf_url} <- upload_file(bucket, pdf_path, pdf_key, region) do
        
        # Delete local files after successful upload if requested
        if delete_after_upload do
          delete_file(html_path)
          delete_file(screenshot_path)
          delete_file(pdf_path)
          Logger.info("Deleted local files after successful S3 upload")
        end
        
        # Return S3 URLs
        {:ok,
         %{
           html_url: html_url,
           screenshot_url: screenshot_url,
           pdf_url: pdf_url
         }}
      else
        {:error, reason} -> {:error, reason}
      end
    rescue
      e ->
        Logger.error("Failed to upload files to S3: #{Exception.message(e)}")
        Logger.error(Exception.format_stacktrace(__STACKTRACE__))
        {:error, "S3 upload failed: #{Exception.message(e)}"}
    end
  end

  @doc """
  Uploads a single file to S3.

  ## Returns

    * `{:ok, s3_url}` on success
    * `{:error, reason}` on failure
  """
  def upload_file(bucket, file_path, s3_key, region) do
    case File.read(file_path) do
      {:ok, file_content} ->
        try do
          # Set content type based on file extension
          content_type = get_content_type(file_path)

          # Use ExAws to upload file with metadata
          # No ACL specified - rely on bucket policy for public access
          operation =
            ExAws.S3.put_object(bucket, s3_key, file_content,
              content_type: content_type,
              meta: [
                "original-filename": Path.basename(file_path),
                "upload-date": DateTime.utc_now() |> DateTime.to_iso8601()
              ]
            )

          # Execute request with proper AWS configuration  
          # Get credentials directly from environment
          access_key_id = System.get_env("AWS_ACCESS_KEY_ID")
          secret_access_key = System.get_env("AWS_SECRET_ACCESS_KEY")

          # Log warning if credentials are missing
          if is_nil(access_key_id) or is_nil(secret_access_key) do
            Logger.warning("AWS credentials not found in environment variables!")
          end

          result =
            operation
            |> ExAws.request(
              region: region,
              access_key_id: access_key_id,
              secret_access_key: secret_access_key
            )

          case result do
            {:ok, _response} ->
              s3_url = "https://#{bucket}.s3.#{region}.amazonaws.com/#{s3_key}"
              Logger.info("Successfully uploaded to S3: #{s3_url}")
              {:ok, s3_url}

            {:error, error} ->
              Logger.error("S3 upload error: #{inspect(error)}")
              {:error, "Failed to upload to S3: #{inspect(error)}"}
          end
        rescue
          e ->
            Logger.error("S3 upload exception: #{Exception.message(e)}")
            {:error, "S3 upload exception: #{Exception.message(e)}"}
        end

      {:error, reason} ->
        Logger.error("Failed to read file #{file_path}: #{inspect(reason)}")
        {:error, "Failed to read file: #{inspect(reason)}"}
    end
  end

  # Determine content type based on file extension
  defp get_content_type(file_path) do
    case Path.extname(file_path) do
      ".html" -> "text/html"
      ".png" -> "image/png"
      ".jpg" -> "image/jpeg"
      ".jpeg" -> "image/jpeg"
      ".pdf" -> "application/pdf"
      _ -> "application/octet-stream"
    end
  end
  
  # Safely delete a file, handling errors gracefully
  defp delete_file(file_path) do
    try do
      case File.rm(file_path) do
        :ok -> 
          Logger.debug("Successfully deleted file: #{file_path}")
          :ok
        {:error, reason} ->
          Logger.warning("Failed to delete file #{file_path}: #{inspect(reason)}")
          {:error, reason}
      end
    rescue
      e ->
        Logger.warning("Error when deleting file #{file_path}: #{Exception.message(e)}")
        {:error, e}
    end
  end
end

