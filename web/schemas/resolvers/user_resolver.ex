defmodule Web.UserResolver do
    alias Web.Repo
    alias Web.User
    
    def update(%{id: id, user: user_params}, _info) do
        Repo.get!(User, id)
        |> User.update_changeset(user_params)
        |> Repo.update
    end
end