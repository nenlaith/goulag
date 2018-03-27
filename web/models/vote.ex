defmodule Goulag.Vote do
  use Ecto.Schema

  @primary_key { :id, :binary_id, autogenerate: true }
  @foreign_key_type :binary_id

  schema "users_defendants_votes" do
    belongs_to :users, Goulag.User, foreign_key: :user_id
    belongs_to :defendants, Goulag.Defendant, foreign_key: :defendant_id
    field :vote, VoteTypeEnum
    timestamps()
  end
end
