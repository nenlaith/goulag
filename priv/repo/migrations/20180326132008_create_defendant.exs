defmodule Goulag.Repo.Migrations.CreateDefendant do
  use Ecto.Migration

  def up do
    create table(:defendants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :exculpatory_vote, :integer, default: 0
      add :incriminatory_vote, :integer, default: 0
      timestamps()
    end
    create constraint("defendants", "exculpatory_vote_must_be_positive_or_null", check: "exculpatory_vote >= 0", comment: "exculpatory_vote must be >= 0")
    create constraint("defendants", "incriminatory_vote_must_be_positive_or_null", check: "incriminatory_vote >= 0", comment: "incriminatory_vote must be >= 0")
  end

  def down do
    drop constraint("defendants", "exculpatory_vote_must_be_positive_or_null")
    drop constraint("defendants", "incriminatory_vote_must_be_positive_or_null")
    drop table(:defendants)
  end
end
