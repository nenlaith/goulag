defmodule Goulag.Language do
  use Ecto.Schema

  @primary_key { :id, :binary_id, autogenerate: true }
  @foreign_key_type :binary_id

  schema "languages" do
    field :name, :string
    field :iso_name, :string
    has_many :defendant_translations, Goulag.Translation
  end
end
