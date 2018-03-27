defmodule Goulag.Defendant do
  use Goulag.Web, :model

  schema "defendants" do
    field :exculpatory_vote, :integer, default: 0
    field :incriminatory_vote, :integer, default: 0
    field :image_url, :string
    field :defendant_url, :string
    has_many :defendant_translations, Goulag.Translation
    has_many :users_defendants_votes, Goulag.Vote
    timestamps()
  end
end
