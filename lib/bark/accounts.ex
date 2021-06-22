defmodule Bark.Accounts do
  alias Bark.Repo
  alias Bark.Accounts.User

  def sign_in(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        { :ok, user }
      true ->
        { :error, :unauthorized }
    end
  end

  def user_signed_in?(conn), do: !!current_user(conn)

  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: Repo.get(User, user_id)
  end

  def sign_out(conn) do
    Plug.Conn.configure_session(conn, drop: true)
  end

  def register(params) do
    User.registration_changeset(%User{}, params) |> Repo.insert()
  end

  def list_users(params) do
    search_term = get_in(params, ["query"])
    
    User
    |> User.search(search_term)
    |> Repo.all()
  end

  def get_by_username(username), do: Repo.get_by(User, username: username)

  def get_user!(id), do: Repo.get!(User, id)

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_user_password(%User{} = user, attrs) do
    user
    |> User.update_password_changeset(attrs)
    |> Repo.update()
  end

  def update_user_profile_pic(%User{} = user, attrs) do
    user
    |> User.profile_pic_changeset(attrs)
    |> Repo.update()
  end

  def update_user_cover_pic(%User{} = user, attrs) do
    user
    |> User.cover_pic_changeset(attrs)
    |> Repo.update()
  end
  
  def change_user_cover_pic(%User{} = user) do
    User.cover_pic_changeset(user, %{})
  end
  
  def change_user_profile_pic(%User{} = user) do
    User.profile_pic_changeset(user, %{})
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end