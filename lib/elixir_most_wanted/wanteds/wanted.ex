defmodule ElixirMostWanted.Wanteds.Wanted do
  use Ecto.Schema
  @derive {Phoenix.Param, key: :slug_id}

  schema "wanteds" do
    belongs_to :user, ElixirMostWanted.Accounts.User
    field :name, :string
    field :purpose, :string
    field :body, :string
    field :slug_id, :string
    field :completed_at, :utc_datetime
    field :vote_count, :integer, virtual: true
    has_many :votes, ElixirMostWanted.Wanteds.Vote
    timestamps(type: :utc_datetime)
  end
end
