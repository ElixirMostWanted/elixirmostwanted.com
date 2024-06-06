defmodule ElixirMostWanted.Wanteds do
  import Ecto.Changeset
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

  def get_wanted_by_slug_id!(slug_id) do
    Repo.get_by!(Wanted, slug_id: slug_id)
  end

  def change_wanted(%Wanted{} = wanted, attrs \\ %{}) do
    wanted
    |> cast(attrs, [:name, :purpose])
    |> validate_required([:name, :purpose])
  end

  def insert_wanted(%Wanted{} = wanted, attrs) do
    wanted
    |> change_wanted(attrs)
    |> prepare_changes(fn changeset ->
      slug_id =
        changeset
        |> fetch_change!(:name)
        |> slugify()

      count =
        changeset.repo.one!(
          from w in Wanted,
            where: fragment("? ~ ?", w.slug_id, ^"\\A#{slug_id}(-\\d+)?\\Z"),
            select: count(w)
        )

      slug_id = slug_id <> if(count > 0, do: "-#{count + 1}", else: "")

      put_change(changeset, :slug_id, slug_id)
    end)
    |> Repo.insert()
  end

  defp slugify(name) do
    name
    |> String.trim()
    |> String.replace(~r/\s+/, "-")
    |> String.replace(~r/-+/, "-")
    |> String.to_charlist()
    |> Enum.reject(&URI.char_reserved?/1)
    |> List.to_string()
    |> String.downcase()
  end
end
