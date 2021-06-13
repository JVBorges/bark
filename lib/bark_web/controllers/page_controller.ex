defmodule BarkWeb.PageController do
  use BarkWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
