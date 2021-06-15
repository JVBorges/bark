defmodule BarkWeb.SessionController do
  use BarkWeb, :controller

  alias Bark.Accounts

  plug :put_layout, "index.html"
  
  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{ "email" => email, "password" => password }}) do
    case Accounts.sign_in(email, password) do
      { :ok, user } ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "You've signed in")
        |> redirect(to: "/timeline")
      { :error, _} ->
        conn
        |> put_flash(:error, "Invalid Email or Password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Accounts.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
