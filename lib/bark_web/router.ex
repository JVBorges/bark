defmodule BarkWeb.Router do
  use BarkWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BarkWeb.Plugs.SetUser
  end

  pipeline :auth do
    plug BarkWeb.Plugs.AuthUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BarkWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources("/session", SessionController, only: [:create])
    get "/login", SessionController, :new

    resources("/registration", RegistrationController, only: [:create])
    get "/signup", RegistrationController, :new
    
    delete "/sign_out", SessionController, :delete

    get "/search", UserController, :search
    get "/p/:username", UserController, :show
  end

  scope "/", BarkWeb do
    pipe_through [:browser, :auth]

    resources("/posts", PostController, except: [:index, :show, :new])
    get "/timeline", PostController, :index
  end

  scope "/user", BarkWeb do
    pipe_through [:browser, :auth]

    get "/settings", UserSettingsController, :index
    put "/settings/update_user/:id", UserSettingsController, :update_user
    put "/settings/update_password/:id", UserSettingsController, :update_password
    put "/settings/update_avatar", UserSettingsController, :update_avatar
    put "/settings/update_cover", UserSettingsController, :update_cover
  end

  # Other scopes may use custom stacks.
  # scope "/api", BarkWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BarkWeb.Telemetry
    end
  end
end
