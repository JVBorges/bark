defmodule BarkWeb.PageController do
  use BarkWeb, :controller

  def index(conn, _params) do
    if conn.assigns.current_user do
      conn |> redirect(to: "/timeline") |> halt()
    else
      render(conn, "index.html", layout: { BarkWeb.LayoutView, "index.html" })
    end
  end
end
