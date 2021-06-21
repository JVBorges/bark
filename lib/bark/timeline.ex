defmodule Bark.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query
  
  alias Bark.Repo

  alias Bark.Timeline.Post
  alias Bark.Accounts.User
  alias Bark.Accounts

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all from p in Post,
            join: u in User, on: u.id == p.user_id, 
            preload: [user: u],
            select: [:id, :body, :inserted_at, :user_id, user: [:id, :username]],
            order_by: [desc: p.id]     
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  def get_post_by_username!(username) do
    user_fetched = Accounts.get_by_username(username)
    Repo.all from p in Post,
             join: u in User, on: u.id == p.user_id, 
             preload: [user: u],
             select: [:id, :body, :inserted_at, :user_id, user: [:id, :username, :profile_pic_url, :cover_pic_url]],
             where: p.user_id == ^user_fetched.id,
             order_by: [desc: p.id],
             limit: 20
  end

  def get_user_posts!(username) do
    Repo.all from u in User,
             join: p in Post, on: p.user_id == u.id,
             preload: [posts: p],
             select: [:id, :username, :profile_pic_url, :cover_pic_url, posts: [:id, :body, :inserted_at, :user_id]],
             where: u.username == ^username,
             order_by: [desc: p.id],
             limit: 20
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:posts)
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
