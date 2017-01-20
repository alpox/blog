defmodule Web.PostController do
  use Web.Web, :controller
  alias Web.Post
  alias Web.Repo

  def index(conn, _params) do
    json conn, Repo.all(Post)
  end

  def show(conn, %{"id" => id}) do
    post = Post
      |> where([p], p.id == ^id)
      |> Repo.one

    json conn, post
  end
end
