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
    user = Timeline.get_user_posts!(username)
    if Enum.empty?(user) do
      render(conn, "404.html")
    else      
      render(conn, "show.html", user: List.first(user))
    end
  end
end