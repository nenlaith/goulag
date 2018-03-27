defmodule Goulag.Translation do
  use Ecto.Schema

  @primary_key { :id, :binary_id, autogenerate: true }
  @foreign_key_type :binary_id

  schema "defendant_translations" do
    belongs_to :languages, Goulag.Language, foreign_key: :language_id
    belongs_to :defendants, Goulag.Defendant, foreign_key: :defendant_id
    field :defendant_name, :string
    field :defendant_text, :string
    timestamps()
  end
end
