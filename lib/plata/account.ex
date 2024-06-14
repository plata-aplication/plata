defmodule Plata.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Plata.Repo

  alias Plata.Account.User

  def get_user_by_email_and_password(%{"email" => email, "password" => password}) do
    case Repo.one(from User, where: [email: ^email]) do
      nil ->
        :error

      user ->
        if User.valid_password?(user, password) do
          {:ok, user}
        else
          :error
        end
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.register_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
