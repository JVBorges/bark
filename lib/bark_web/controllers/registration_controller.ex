defmodule BarkWeb.RegistrationController do
  use BarkWeb, :controller

  alias Bark.Accounts

  def new(conn, _params) do
    render(conn, "new.html", changeset: conn)
  end

  def create(conn, %{"registration" => registration_params}) do
    case Accounts.register(registration_params) do
      { :ok, user } ->
        conn
        |> redirect(to: Route.session_path(conn, :new))
      { :error, changeset } ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
