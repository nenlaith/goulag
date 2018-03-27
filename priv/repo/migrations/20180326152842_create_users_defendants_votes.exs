defmodule Goulag.Repo.Migrations.CreateUsersDefendantsVotes do
  use Ecto.Migration

  def up do
    VoteTypeEnum.create_type
    create table(:users_defendants_votes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references("users", column: :id, type: :binary_id, on_delete: :delete_all), null: false
      add :defendant_id, references("defendants", column: :id, type: :binary_id, on_delete: :delete_all), null: false
      add :vote, :vote_type, null: false
      timestamps()
    end
    create unique_index(:users_defendants_votes, [:user_id, :defendant_id])
  end

  def down do
    drop table(:users_defendants_votes)
    VoteTypeEnum.drop_type
  end
end
