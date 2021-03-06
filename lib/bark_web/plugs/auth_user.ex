defmodule BarkWeb.Plugs.AuthUser do
  import Plug.Conn
  import Phoenix.Controller

  alias BarkWeb.Router.Helpers, as: Routes

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.signed_in? do
			conn
		else
			conn
			|> put_flash(:error, "You need to be signed in!")
			|> redirect(to: Routes.session_path(conn, :new))
			|> halt()
		end
  end
end