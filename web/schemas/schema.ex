defmodule Web.Schema do
    use Absinthe.Schema

    @desc "A post"
    object :post do
        field :id, :id
        field :title, :string
        field :content, :string
        field :summary, :string
    end

    @desc "A user"
    object :user do
        field :id, :id
        field :username, :string
        field :email, :string
    end

    input_object :update_user_params do
        field :username, :string
        field :email, :string
        field :password, :string
    end

    mutation do
        field :update_user, type: :user do
            arg :id, non_null(:integer)
            arg :user, :update_user_params

            resolve &Web.UserResolver.update/2
        end
    end

    query do
        field :post, :post do
            arg :id, non_null(:id)
            resolve &Web.PostResolver.one/2
        end

        field :posts, list_of(:post) do
            resolve &Web.PostResolver.all/2
        end
    end
end