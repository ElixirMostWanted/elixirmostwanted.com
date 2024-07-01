defmodule ElixirMostWanted.Wanteds.WantedTest do
  use ElixirMostWanted.DataCase, async: true

  alias ElixirMostWanted.Wanteds.Wanted
  alias ElixirMostWanted.Wanteds.Vote
  alias ElixirMostWanted.Accounts.User

  describe "wanted" do
    test "update vote_count after related vote insert" do
      user = Repo.insert!(%User{})

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

      Repo.insert!(%Vote{wanted_id: wanted.id})
      Repo.insert!(%Vote{wanted_id: wanted.id})
      Repo.insert!(%Vote{wanted_id: wanted2.id})

      wanted = Repo.get!(Wanted, wanted.id)
      wanted2 = Repo.get!(Wanted, wanted2.id)

      assert wanted.vote_count == 2
      assert wanted2.vote_count == 1
    end
  end
end
