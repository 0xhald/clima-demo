defmodule Clima.Favorites do
  @moduledoc """
  The Favorites context.
  """

  import Ecto.Query, warn: false
  alias Clima.Repo

  alias Clima.Favorites.Favorite
  alias Clima.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any favorite changes.

  The broadcasted messages match the pattern:

    * {:created, %Favorite{}}
    * {:updated, %Favorite{}}
    * {:deleted, %Favorite{}}

  """
  def subscribe_favorites(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Clima.PubSub, "user:#{key}:favorites")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Clima.PubSub, "user:#{key}:favorites", message)
  end

  @doc """
  Returns the list of favorites.

  ## Examples

      iex> list_favorites(scope)
      [%Favorite{}, ...]

  """
  def list_favorites(%Scope{} = scope) do
    Repo.all_by(Favorite, user_id: scope.user.id)
  end

  @doc """
  Gets a single favorite.

  Raises `Ecto.NoResultsError` if the Favorite does not exist.

  ## Examples

      iex> get_favorite!(123)
      %Favorite{}

      iex> get_favorite!(456)
      ** (Ecto.NoResultsError)

  """
  def get_favorite!(%Scope{} = scope, id) do
    Repo.get_by!(Favorite, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a favorite.

  ## Examples

      iex> create_favorite(%{field: value})
      {:ok, %Favorite{}}

      iex> create_favorite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_favorite(%Scope{} = scope, attrs) do
    with {:ok, favorite = %Favorite{}} <-
           %Favorite{}
           |> Favorite.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, favorite})
      {:ok, favorite}
    end
  end

  @doc """
  Updates a favorite.

  ## Examples

      iex> update_favorite(favorite, %{field: new_value})
      {:ok, %Favorite{}}

      iex> update_favorite(favorite, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_favorite(%Scope{} = scope, %Favorite{} = favorite, attrs) do
    true = favorite.user_id == scope.user.id

    with {:ok, favorite = %Favorite{}} <-
           favorite
           |> Favorite.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, favorite})
      {:ok, favorite}
    end
  end

  @doc """
  Deletes a favorite.

  ## Examples

      iex> delete_favorite(favorite)
      {:ok, %Favorite{}}

      iex> delete_favorite(favorite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_favorite(%Scope{} = scope, %Favorite{} = favorite) do
    true = favorite.user_id == scope.user.id

    with {:ok, favorite = %Favorite{}} <-
           Repo.delete(favorite) do
      broadcast(scope, {:deleted, favorite})
      {:ok, favorite}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking favorite changes.

  ## Examples

      iex> change_favorite(favorite)
      %Ecto.Changeset{data: %Favorite{}}

  """
  def change_favorite(%Scope{} = scope, %Favorite{} = favorite, attrs \\ %{}) do
    true = favorite.user_id == scope.user.id

    Favorite.changeset(favorite, attrs, scope)
  end
end
