defmodule Web.Schema do
    use Absinthe.Schema
    use Absinthe.Ecto, repo: Web.Repo

    @desc "A post"
    object :post do
        field :id, :string
        field :title, :string
        field :content, :string
        field :summary, :string
        field :inserted_at, :string
        field :user, :user, resolve: assoc(:user)
    end

    @desc "A user"
    object :user do
        field :id, :string
        field :username, :string
        field :email, :string
        field :posts, list_of(:post), resolve: assoc(:posts)
    end

    object :session do
        field :token, :string
        field :exp, :string
    end

    input_object :update_user_params do
        field :username, :string
        field :email, :string
        field :password, :string
    end

    input_object :update_post_params do
        field :title, :string
        field :content, :string
        field :summary, :string
    end

    mutation do
        field :update_user, type: :user do
            arg :id, non_null(:string)
            arg :user, :update_user_params

            resolve &Web.UserResolver.update/2
        end

        field :login, type: :session do
            arg :username, non_null(:string)
            arg :password, non_null(:string)
        
            resolve &Web.UserResolver.login/2
        end

        field :update_post, type: :post do
            arg :id, non_null(:string)
            arg :post, :update_post_params
            
            resolve &Web.PostResolver.update/2
        end

        field :insert_post, type: :post do
            arg :post, :update_post_params

            resolve &Web.PostResolver.insert/2
        end

        field :delete_post, type: :post do
            arg :id, non_null(:string)

            resolve &Web.PostResolver.delete/2
        end
    end

    query do
        field :post, :post do
            arg :id, non_null(:string)
            resolve &Web.PostResolver.one/2
        end

        field :posts, list_of(:post) do
            resolve &Web.PostResolver.all/2
        end
    end
end