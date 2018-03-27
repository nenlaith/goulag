defmodule Goulag.Repo.Migrations.ChangeUser do
  use Ecto.Migration

  def up do
    alter table(:users) do
      modify :password_hash, :text, null: false
    end
  end

  def down do
    alter table(:users) do
      modify :password_hash, :string
    end
  end
end
