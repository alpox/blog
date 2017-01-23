defmodule Web.PostResolver do
    import Ecto.Query, only: [where: 2]

    alias Web.Repo
    alias Web.Post
    
    def all(_params, _info) do
        {:ok, Repo.all(Post)}
    end

    def one(%{ id: post_id }, _) do
        {:ok, Post |> where(id: ^post_id) |> Repo.one}
    end
end