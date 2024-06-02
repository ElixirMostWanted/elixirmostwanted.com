defmodule ElixirMostWanted.Repo.Migrations.AddWantedsTable do
  use Ecto.Migration

  def change do
    create table(:wanteds) do
      add :user_id, references(:users, on_delete: :delete_all)

      add :name, :text
      add :purpose, :text
      add :body, :text
      add :slug_id, :string, null: false
      add :completed_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:wanteds, [:slug_id])
  end
end
