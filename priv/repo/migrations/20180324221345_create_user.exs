defmodule Goulag.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pgcrypto"
    execute "CREATE EXTENSION IF NOT EXISTS uuid-ossp"
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string, null: false
      add :password_hash, :string
      timestamps
    end
    create unique_index(:users, [:username])
  end
end
