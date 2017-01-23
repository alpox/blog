defmodule Web.Model.Schema do
  defmacro __using__(_) do
    quote do
      use Web.Web, :model
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end