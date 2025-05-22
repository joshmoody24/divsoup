defmodule DivsoupWeb.Router do
  use DivsoupWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DivsoupWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DivsoupWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/about", PageController, :about
    get "/achievements", PageController, :list_achievements
    post "/request-analysis", PageController, :request_analysis
    
    # Analysis routes
    get "/analysis/by-url/:url", PageController, :list_jobs_by_url
    get "/analysis/:id", PageController, :view_job
  end

  # Other scopes may use custom stacks.
  # scope "/api", DivsoupWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:divsoup_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DivsoupWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
