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

    def insert(post_params, %{context: %{current_user: %{id: _}}}) do
        Repo.insert(Post.insert_changeset post_params.post)
    end

    def insert(_args, _info) do
        {:error, "Not Authorized"}
    end

    def update(%{id: id, post: post_params}, %{context: %{current_user: %{id: _}}}) do
        Repo.get!(Post, id)
        |> Post.update_changeset(post_params)
        |> Repo.update
    end

    def update(_args, _info) do
        {:error, "Not Authorized"}
    end

    def delete(%{id: id}, %{context: %{current_user: %{id: _}}}) do
        Repo.delete %Post{ id: id }
    end

    def delete(_args, _info) do
        {:error, "Not Authorized"}
    end
end