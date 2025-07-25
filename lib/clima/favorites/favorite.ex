defmodule Clima.Favorites.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorites" do
    field :name, :string
    field :country, :string
    field :state, :string
    field :lat, :float
    field :lon, :float
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(favorite, attrs, user_scope) do
    favorite
    |> cast(attrs, [:name, :country, :state, :lat, :lon])
    |> validate_required([:name, :country, :lat, :lon])
    |> validate_number(:lat, greater_than_or_equal_to: -90, less_than_or_equal_to: 90)
    |> validate_number(:lon, greater_than_or_equal_to: -180, less_than_or_equal_to: 180)
    |> put_change(:user_id, user_scope.user.id)
    |> unique_constraint([:user_id, :lat, :lon])
  end
end
