defmodule ElixirMostWanted.Repo.Migrations.InitCore do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :name, :string
      add :token, :string
      add :avatar_url, :string
      add :external_homepage_url, :string
      add :visibility, :integer, null: false, default: 1

      timestamps()
    end

    create unique_index(:users, [:name])
  end
end
