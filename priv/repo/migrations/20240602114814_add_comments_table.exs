defmodule ElixirMostWanted.Repo.Migrations.AddCommentsTable do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :wanted_id, references(:wanteds, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      add :body, :text

      timestamps(type: :utc_datetime)
    end
  end
end
