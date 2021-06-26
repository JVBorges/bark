defmodule BarkWeb.UserController do
  use BarkWeb, :controller

  alias Bark.Accounts
  alias Bark.Timeline

  def search(conn, params) do
    users = Accounts.list_users(params)
    IO.inspect users
    render(conn, "search.html", users: users)
  end

  def show(conn, %{"username" => username}) do
    [user | _] = Timeline.get_user_posts!(username)
    render(conn, "show.html", user: user)
  end
end