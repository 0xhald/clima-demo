defmodule Clima.FavoritesTest do
  use Clima.DataCase

  alias Clima.Favorites

  describe "favorites" do
    alias Clima.Favorites.Favorite

    import Clima.AccountsFixtures, only: [user_scope_fixture: 0]
    import Clima.FavoritesFixtures

    @invalid_attrs %{name: nil, state: nil, country: nil, lat: nil, lon: nil}

    test "list_favorites/1 returns all scoped favorites" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      favorite = favorite_fixture(scope)
      other_favorite = favorite_fixture(other_scope)
      assert Favorites.list_favorites(scope) == [favorite]
      assert Favorites.list_favorites(other_scope) == [other_favorite]
    end

    test "get_favorite!/2 returns the favorite with given id" do
      scope = user_scope_fixture()
      favorite = favorite_fixture(scope)
      other_scope = user_scope_fixture()
      assert Favorites.get_favorite!(scope, favorite.id) == favorite
      assert_raise Ecto.NoResultsError, fn -> Favorites.get_favorite!(other_scope, favorite.id) end
    end

    test "create_favorite/2 with valid data creates a favorite" do
      valid_attrs = %{name: "some name", state: "some state", country: "some country", lat: 120.5, lon: 120.5}
      scope = user_scope_fixture()

      assert {:ok, %Favorite{} = favorite} = Favorites.create_favorite(scope, valid_attrs)
      assert favorite.name == "some name"
      assert favorite.state == "some state"
      assert favorite.country == "some country"
      assert favorite.lat == 120.5
      assert favorite.lon == 120.5
      assert favorite.user_id == scope.user.id
    end

    test "create_favorite/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Favorites.create_favorite(scope, @invalid_attrs)
    end

    test "update_favorite/3 with valid data updates the favorite" do
      scope = user_scope_fixture()
      favorite = favorite_fixture(scope)
      update_attrs = %{name: "some updated name", state: "some updated state", country: "some updated country", lat: 456.7, lon: 456.7}

      assert {:ok, %Favorite{} = favorite} = Favorites.update_favorite(scope, favorite, update_attrs)
      assert favorite.name == "some updated name"
      assert favorite.state == "some updated state"
      assert favorite.country == "some updated country"
      assert favorite.lat == 456.7
      assert favorite.lon == 456.7
    end

    test "update_favorite/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      favorite = favorite_fixture(scope)

      assert_raise MatchError, fn ->
        Favorites.update_favorite(other_scope, favorite, %{})
      end
    end

    test "update_favorite/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      favorite = favorite_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Favorites.update_favorite(scope, favorite, @invalid_attrs)
      assert favorite == Favorites.get_favorite!(scope, favorite.id)
    end

    test "delete_favorite/2 deletes the favorite" do
      scope = user_scope_fixture()
      favorite = favorite_fixture(scope)
      assert {:ok, %Favorite{}} = Favorites.delete_favorite(scope, favorite)
      assert_raise Ecto.NoResultsError, fn -> Favorites.get_favorite!(scope, favorite.id) end
    end

    test "delete_favorite/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      favorite = favorite_fixture(scope)
      assert_raise MatchError, fn -> Favorites.delete_favorite(other_scope, favorite) end
    end

    test "change_favorite/2 returns a favorite changeset" do
      scope = user_scope_fixture()
      favorite = favorite_fixture(scope)
      assert %Ecto.Changeset{} = Favorites.change_favorite(scope, favorite)
    end
  end
end
