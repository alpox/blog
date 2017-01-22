defmodule Web.Schema do
    use Absinthe.Schema

    import Ecto.Query

    alias Web.Post
    alias Web.Repo

    query do
        field :post, :post do
            arg :id, non_null(:id)
            resolve fn %{id: post_id}, _ ->
                {:ok, Post |> where([e], e.id == ^post_id) |> Repo.one}
            end
        end


        field :posts, list_of(:post) do
            resolve fn _, _->
                {:ok, Repo.all(Post) }
            end
        end
    end


    @desc "An item"
    object :post do
        field :id, :id
        field :title, :string
        field :content, :string
        field :summary, :string
    end
end