defmodule Goulag.User do
  use Ecto.Schema

  @primary_key { :id, :binary_id, autogenerate: true }
  @foreign_key_type :binary_id

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string, read_after_writes: true
    has_many :users_defendants_votes, Goulag.Vote
    timestamps()
  end
end
