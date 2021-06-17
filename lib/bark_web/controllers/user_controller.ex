defmodule BarkWeb.UserController do
  use BarkWeb, :controller

  alias Bark.Accounts
  alias Bark.Accounts.User

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, params) do
    users = Accounts.list_users(params)
    render(conn, "show.html", users: users)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: "/timeline")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "user deleted successfully.")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end