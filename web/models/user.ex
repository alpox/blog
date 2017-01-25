defmodule Web.User do
  use Web.Web, :model

  @derive {Poison.Encoder, only: [:id, :username, :email]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :posts, Web.Post

    timestamps()
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email], [:password])
    |> validate_required([:username, :email])
    |> put_pass_hash()
  end
 
  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> put_pass_hash()
  end
 
  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end