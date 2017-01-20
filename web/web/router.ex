defmodule Web.Router do
  use Web.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Web do
    pipe_through :api

    get "/posts", PostController, :index
    get "/posts/:id", PostController, :show
  end

  scope "/", Web do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Web do
  #   pipe_through :api
  # end
end
