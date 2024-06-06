defmodule ElixirMostWanted.Wanteds do
  import Ecto.Query
  alias ElixirMostWanted.Repo

  alias ElixirMostWanted.Wanteds.{Wanted, Vote}

  def list_most_wanted do
    from(w in Wanted,
      left_join: v in Vote,
      on: v.wanted_id == w.id,
      where: is_nil(w.completed_at),
      group_by: [w.id],
      select: %{w | vote_count: count(v)},
      order_by: [desc: count(v)]
    )
    |> Repo.all()
  end
end
