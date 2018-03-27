defmodule Goulag.Repo.Migrations.CreateTriggerVotes do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE FUNCTION users_vote() RETURNS TRIGGER AS $func$
    BEGIN
      IF (TG_OP = 'UPDATE') THEN
        IF (NEW.vote = 'exculpatory') THEN
          UPDATE defendants SET exculpatory_vote = exculpatory_vote + 1, incriminatory_vote = incriminatory_vote - 1 WHERE id = NEW.defendant_id;
        ELSE
          UPDATE defendants SET exculpatory_vote = exculpatory_vote - 1, incriminatory_vote = incriminatory_vote + 1 WHERE id = NEW.defendant_id;
        END IF;
      END IF;

      IF (TG_OP = 'INSERT') THEN
        IF (NEW.vote = 'exculpatory') THEN
          UPDATE defendants SET exculpatory_vote = exculpatory_vote + 1 WHERE id = NEW.defendant_id;
        ELSE
          UPDATE defendants SET incriminatory_vote = incriminatory_vote + 1 WHERE id = NEW.defendant_id;
        END IF;
      END IF;

      IF (TG_OP = 'DELETE') THEN
        IF (OLD.vote = 'exculpatory') THEN
          UPDATE defendants SET exculpatory_vote = exculpatory_vote - 1 WHERE id = OLD.defendant_id;
        ELSE
          UPDATE defendants SET incriminatory_vote = incriminatory_vote - 1 WHERE id = OLD.defendant_id;
        END IF;
      END IF;

      RETURN NULL;
    END;
    $func$ LANGUAGE plpgsql
    """

    execute "CREATE TRIGGER trigger_users_vote AFTER INSERT OR UPDATE OR DELETE ON users_defendants_votes FOR EACH ROW EXECUTE PROCEDURE users_vote()"
  end

  def down do
    execute "DROP TRIGGER IF EXISTS trigger_users_vote ON users_defendants_votes"

    execute "DROP FUNCTION users_vote()"
  end
end
