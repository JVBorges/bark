defmodule BarkWeb.RegistrationController do
  use BarkWeb, :controller

  alias Bark.Accounts

  plug :put_layout, "index.html"

  def new(conn, _params) do
    render(conn, "new.html", changeset: conn)
  end

  def create(conn, %{"registration" => registration_params}) do
    case Accounts.register(registration_params) do
      { :ok, _ } ->
        conn
        |> redirect(to: "/")
      { :error, changeset } ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
