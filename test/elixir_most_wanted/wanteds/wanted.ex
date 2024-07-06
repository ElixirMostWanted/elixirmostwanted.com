defmodule ElixirMostWanted.Wanteds.WantedTest do
  use ElixirMostWanted.DataCase, async: true

  alias ElixirMostWanted.Wanteds.Wanted
  alias ElixirMostWanted.Wanteds.Vote
  alias ElixirMostWanted.Accounts.User

  describe "wanted" do
    test "update vote_count after related vote insert" do
      user = Repo.insert!(%User{})
      user2 = Repo.insert!(%User{})

      wanted =
        Repo.insert!(
          %Wanted{
            slug_id: "phoenix",
            user_id: user.id
          },
          returning: true
        )

      wanted2 =
        Repo.insert!(
          %Wanted{
            slug_id: "ecto",
            user_id: user.id
          },
          returning: true
        )

      assert wanted.vote_count == 0
      assert wanted2.vote_count == 0

      Repo.insert!(%Vote{wanted_id: wanted.id, user_id: user.id})
      Repo.insert!(%Vote{wanted_id: wanted.id, user_id: user2.id})
      Repo.insert!(%Vote{wanted_id: wanted2.id, user_id: user.id})

      wanted = Repo.get!(Wanted, wanted.id)
      wanted2 = Repo.get!(Wanted, wanted2.id)

      assert wanted.vote_count == 2
      assert wanted2.vote_count == 1
    end

    test "update vote_count after related vote delete" do
      user = Repo.insert!(%User{})
      user2 = Repo.insert!(%User{})

      wanted =
        Repo.insert!(
          %Wanted{
            slug_id: "phoenix",
            user_id: user.id
          },
          returning: true
        )

      wanted2 =
        Repo.insert!(
          %Wanted{
            slug_id: "ecto",
            user_id: user.id
          },
          returning: true
        )

      vote1 = Repo.insert!(%Vote{wanted_id: wanted.id, user_id: user.id})
      _vote2 = Repo.insert!(%Vote{wanted_id: wanted.id, user_id: user2.id})
      vote3 = Repo.insert!(%Vote{wanted_id: wanted2.id, user_id: user.id})

      wanted = Repo.get!(Wanted, wanted.id)
      wanted2 = Repo.get!(Wanted, wanted2.id)

      from(v in Vote,
        where:
          (v.wanted_id == ^vote1.wanted_id and v.user_id == ^vote1.user_id) or
            (v.wanted_id == ^vote3.wanted_id and v.user_id == ^vote3.user_id)
      )
      |> Repo.delete_all()

      wanted = Repo.get!(Wanted, wanted.id)
      wanted2 = Repo.get!(Wanted, wanted2.id)

      assert wanted.vote_count == 1
      assert wanted2.vote_count == 0
    end
  end
end
