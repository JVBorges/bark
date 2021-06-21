defmodule BarkWeb.UserSettingsController do
  use BarkWeb, :controller

  alias Bark.Accounts
  alias Bark.Accounts.User
  plug BarkWeb.Plugs.AuthUser when action in [:index, :edit, :update, :update_avatar, :update_cover, :delete]

  def index(conn, _params) do
    user = Accounts.get_user!(conn.assigns.current_user.id)
    changeset = Accounts.change_user(user)
    render(conn, "index.html", user: user, changeset: changeset)
  end

  def update_user(conn, %{"id" => id, "user" => user_params}) do
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

  def update_password(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    
    case Accounts.update_user_password(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> redirect(to: "/timeline")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", user: user, changeset: changeset)
    end
  end

  def update_avatar(conn, %{"post" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user_profile_pic(user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Avatar updated successfully.")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, _} ->
        conn 
        |> redirect(to: Routes.post_path(conn, :index))
    end
  end

  def update_cover(conn, %{"post" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user_cover_pic(user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Cover updated successfully.")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, _} ->
        conn 
        |> redirect(to: Routes.post_path(conn, :index))
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