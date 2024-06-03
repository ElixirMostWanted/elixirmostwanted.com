defmodule ElixirMostWanted.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table("votes", primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :wanted_id, references(:wanteds, on_delete: :delete_all)
      timestamps(updated_at: false, type: :utc_datetime)
    end

    create unique_index("votes", [:wanted_id, :user_id])
  end
end
