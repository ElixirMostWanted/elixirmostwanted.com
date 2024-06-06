defmodule ElixirMostWanted.Repo.Migrations.MakeWantedUserIdNotNullable do
  use Ecto.Migration

  def change do
    alter table("wanteds") do
      modify :user_id, references("users", on_delete: :delete_all),
        null: false,
        from: {references("users", on_delete: :delete_all), null: true}
    end
  end
end
