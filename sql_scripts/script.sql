CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- CREATION DU TRIGGER POUR LE HACHAGE DU PASSWORD DES USERS --

CREATE OR REPLACE FUNCTION encrypt_password() RETURNS TRIGGER AS $func$
BEGIN
  NEW.password_hash := crypt(NEW.password_hash, gen_salt('bf', 7));
  RETURN NEW;
END;
$func$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS encrypt_user_password ON users;
CREATE TRIGGER encrypt_user_password BEFORE INSERT OR UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE encrypt_password();

-----------------------------------------------------------------

CREATE OR REPLACE FUNCTION before_vote_to_defendant() RETURNS TRIGGER AS $func$
DECLARE
  e_vote_type type_vote
BEGIN
  SELECT vote_type INTO e_vote_type FROM users_defendants_votes WHERE user_id = NEW.user_id AND defendant_id = NEW.defendant_id;
  IF  THEN
    RETURN NEW;
  END IF;


-- CREATE OR REPLACE FUNCTION blob() RETURNS VARCHAR(255) AS $func$
-- DECLARE
--   return_good varchar := 'good';
--   return_bad varchar := 'bad';
--   r_previous_user RECORD;
-- BEGIN
--   SELECT * INTO r_previous_user FROM users WHERE username = 'salut';
--   IF r_previous_user IS NOT NULL THEN
--     RETURN return_good;
--   ELSIF r_previous_user IS NULL THEN
--     RETURN return_bad;
--   END IF;
-- END;
-- $func$ LANGUAGE plpgsql;


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

  IF (TG_OP = 'DELETE' OR TG_OP = 'TRUNCATE') THEN
    IF (NEW.vote = 'exculpatory') THEN
      UPDATE defendants SET exculpatory_vote = exculpatory_vote - 1 WHERE id = NEW.defendant_id;
    ELSE
      UPDATE defendants SET incriminatory_vote = incriminatory_vote - 1 WHERE id = NEW.defendant_id;
    END IF;
  END IF;

  RETURN NULL;
END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_users_vote AFTER INSERT OR UPDATE OR DELETE ON users_defendants_votes FOR EACH ROW EXECUTE PROCEDURE users_vote();
