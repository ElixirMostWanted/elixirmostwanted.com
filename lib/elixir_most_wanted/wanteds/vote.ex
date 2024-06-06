defmodule ElixirMostWanted.Wanteds.Vote do
  use Ecto.Schema

  @primary_key false

  schema "votes" do
    belongs_to :user, ElixirMostWanted.Accounts.User
    belongs_to :wanted, ElixirMostWanted.Wanteds.Wanted
    timestamps(updated_at: false, type: :utc_datetime)
  end
end
