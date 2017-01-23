defmodule Web.Router do
  use Web.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :graphql do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Web.Context
  end

  scope "/graphql" do
    pipe_through :graphql

    forward "/", Absinthe.Plug, 
      schema: Web.Schema
  end
  
  scope "/", Web do
    pipe_through :browser

    get "/", PageController, :index
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL, 
    schema: Web.Schema
end
