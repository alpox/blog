defmodule Web.UserResolver do
    alias Web.Repo
    alias Web.User

    def update(%{id: id, user: user_params}, _info) do
        Repo.get!(User, id)
        |> User.update_changeset(user_params)
        |> Repo.update
    end

    def login(params, _info) do
        with {:ok, user} <- Web.Session.authenticate(params),
            {:ok, jwt, claims } <- Guardian.encode_and_sign(user, :access) do
            exp = Map.get(claims, "exp")
            {:ok, %{token: jwt, exp: exp}}
        end
    end
end