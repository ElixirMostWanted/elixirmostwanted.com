defmodule ElixirMostWanted.Repo.Migrations.AddVoteCountToWantedsTable do
  use Ecto.Migration

  def change do
    alter table("wanteds") do
      add :vote_count, :integer, null: false, default: 0
    end

    execute """
    CREATE OR REPLACE FUNCTION update_wanted_vote_count()
    RETURNS TRIGGER AS $$
    BEGIN
        UPDATE wanteds
        SET vote_count = vote_count + 1
        WHERE id = NEW.wanted_id;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    """

    execute """
    CREATE TRIGGER after_vote_insert
      AFTER INSERT ON votes
      FOR EACH ROW
      EXECUTE FUNCTION update_wanted_vote_count();
    """
  end
end
