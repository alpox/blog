defmodule Web.Router do
  use Web.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  post "/graphql", Absinthe.Plug, schema: Web.Schema

  get "/graphiql", Absinthe.Plug.GraphiQL, schema: Web.Schema
  
  scope "/", Web do
    pipe_through :browser

    get "/", PageController, :index
  end
end
