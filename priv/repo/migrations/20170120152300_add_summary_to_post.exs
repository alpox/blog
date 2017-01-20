defmodule Web.Repo.Migrations.AddSummaryToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :summary, :string
    end
  end
end
