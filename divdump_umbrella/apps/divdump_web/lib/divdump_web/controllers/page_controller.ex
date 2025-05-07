defmodule DivdumpWeb.PageController do
  use DivdumpWeb, :controller

  def home(conn, _params) do
    conn
    |> render(:home)
  end

  def about(conn, _params) do
    conn
    |> render(:about)
  end

  def request_analysis(conn, %{"url" => url}) do
    # Here you would typically call a service to perform the analysis
    # For now, we'll just simulate it with a simple message
    analysis_result = "Analysis result for #{url}"
    encoded_url = URI.encode(url)

    conn
    |> put_flash(:info, analysis_result)
    |> redirect(to: ~p"/analysis/#{encoded_url}")
  end

  def analysis_result(conn, %{"url" => url}) do
    analysis_result = %{
      url: url,
      details: "This is a detailed analysis of the URL."
    }

    conn
    |> render(:analysis_results, analysis: analysis_result)
  end
end
