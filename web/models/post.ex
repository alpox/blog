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
end