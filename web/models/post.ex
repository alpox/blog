defmodule Web.Post do
  use Web.Web, :model

  @derive {Poison.Encoder, only: [:id, :title, :content, :summary]}
  schema "posts" do
    field :title, :string
    field :content, :string
    field :summary, :string

    belongs_to :user, Web.User

    timestamps()
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :summary])
    |> validate_required([:title])
  end

  def insert_changeset(params \\ %{}) do
    %Web.Post{}
    |> cast(params, [:title, :content, :summary])
  end
end