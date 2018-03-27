defmodule Goulag.Repo.Migrations.CreateTriggerUsers do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION encrypt_password() RETURNS TRIGGER AS $func$
      BEGIN
        NEW.password_hash := crypt(NEW.password_hash, gen_salt('bf', 7));
        RETURN NEW;
      END;
      $func$ LANGUAGE plpgsql
    """

    execute "CREATE TRIGGER encrypt_user_password BEFORE INSERT OR UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE encrypt_password()"
  end

  def down do
    execute "DROP TRIGGER IF EXISTS encrypt_user_password ON users"

    execute "DROP FUNCTION encrypt_password()"
  end
end
