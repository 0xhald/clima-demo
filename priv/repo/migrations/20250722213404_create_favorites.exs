defmodule Clima.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites) do
      add :name, :string
      add :country, :string
      add :state, :string
      add :lat, :float
      add :lon, :float
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:favorites, [:user_id])
  end
end
