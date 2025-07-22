defmodule Clima.FavoritesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Clima.Favorites` context.
  """

  @doc """
  Generate a favorite.
  """
  def favorite_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        country: "some country",
        lat: 120.5,
        lon: 120.5,
        name: "some name",
        state: "some state"
      })

    {:ok, favorite} = Clima.Favorites.create_favorite(scope, attrs)
    favorite
  end
end
