defmodule ElixirMostWanted.Wanteds.Wanted do
  use Ecto.Schema

  schema "wanteds" do
    field :name, :string
    field :purpose, :string
    field :body, :string
    field :slug_id, :string
    field :completed_at, :utc_datetime
    has_many :votes, ElixirMostWanted.Wanteds.Vote
    timestamps(type: :utc_datetime)
  end
end
