defmodule DivsoupWeb.PageControllerTest do
  use DivsoupWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "divsoup"
    assert html_response(conn, 200) =~ "Paste HTML"
    assert html_response(conn, 200) =~ "Analyze HTML"
  end

  test "analysis routes are removed", %{conn: conn} do
    assert_error_sent 404, fn ->
      get(conn, "/analysis/test")
    end

    assert_error_sent 404, fn ->
      post(conn, "/request-analysis", %{"url" => "https://example.com"})
    end
  end
end
