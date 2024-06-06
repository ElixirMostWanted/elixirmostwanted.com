defmodule ElixirMostWantedWeb.Router do
  use ElixirMostWantedWeb, :router

  import ElixirMostWantedWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ElixirMostWantedWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirMostWantedWeb do
    pipe_through :browser

    live "/", HomeLive.Index, :index
  end

  scope "/", ElixirMostWantedWeb do
    pipe_through :browser

    get "/oauth/callbacks/:provider", OAuthCallbackController, :new
  end

  scope "/", ElixirMostWantedWeb do
    pipe_through :browser

    delete "/auth/logout", OAuthCallbackController, :sign_out

    live_session :default,
      on_mount: [{ElixirMostWantedWeb.UserAuth, :current_user}, ElixirMostWantedWeb.Nav] do
      live "/auth/login", SignInLive, :index
    end
  end

  scope "/", ElixirMostWantedWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ElixirMostWantedWeb.UserAuth, :ensure_authenticated}] do
      live "/new", HomeLive.Index, :new
    end
  end

  scope "/", ElixirMostWantedWeb do
    pipe_through :browser

    live "/:slug_id", WantedLive.Show, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirMostWantedWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elixir_most_wanted, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElixirMostWantedWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
