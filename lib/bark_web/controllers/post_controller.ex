defmodule BarkWeb.PostController do
  use BarkWeb, :controller

  alias Bark.Timeline
  alias Bark.Timeline.Post
  plug BarkWeb.Plugs.AuthUser when action in [:index]
	plug :authorize_user when action in [:edit, :update, :delete]

  def index(conn, _params) do
    posts = Timeline.list_posts()
    changeset = Timeline.change_post(%Post{})
    render(conn, "index.html", posts: posts, changeset: changeset)  
  end

  def create(conn, %{"post" => post_params}) do
    case Timeline.create_post(conn.assigns.current_user, post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: "/timeline")

      {:error, %Ecto.Changeset{} = changeset} ->
        posts = Timeline.list_posts()
        render(conn, "index.html", posts: posts, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Timeline.get_post!(id)
    changeset = Timeline.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Timeline.get_post!(id)

    case Timeline.update_post(post, post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: "/timeline")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Timeline.get_post!(id)
    {:ok, _post} = Timeline.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  def can_access?(user, post) do
    user && user.id == post.user_id
  end

  defp authorize_user(conn, _params) do
		%{params: %{"id" => post_id}} = conn
		post = Timeline.get_post!(post_id)

		if conn.assigns.current_user.id == post.user_id do
			conn
		else 
			conn 
			|> put_flash(:info, "You don't have authorization!")
			|> redirect(to: Routes.post_path(conn, :index))
			|> halt()
		end
	end
end
