defmodule Goulag.Repo.Migrations.CreateI18nDefendants do
  use Ecto.Migration

  def up do
    create table(:languages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :iso_name, :char, size: 2, null: false
    end
    create unique_index(:languages, [:name])
    create unique_index(:languages, [:iso_name])

    create table(:defendant_translations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :defendant_id, references("defendants", column: :id, type: :binary_id, on_delete: :delete_all), null: false
      add :language_id, references("languages", column: :id, type: :binary_id, on_delete: :delete_all), null: false
      add :defendant_name, :string, null: false
      add :defendant_text, :text, null: false
      timestamps()
    end
    create unique_index(:defendant_translations, [:language_id, :defendant_id])

    alter table(:defendants) do
      add :image_url, :string
      add :defendant_url, :string
    end
  end

  def down do
    drop table(:defendant_translations)
    drop table(:languages)
    alter table(:defendants) do
      remove :image_url
      remove :defendant_url
    end
  end
end
