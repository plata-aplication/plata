defmodule Plata.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false

  alias Plata.Repo
  alias Plata.Account
  alias Plata.Auth.AccessToken

  def register(register_data) do
    Repo.transaction(fn ->
      with {:ok, user} <- Account.create_user(register_data),
           {:ok, token} <- create_access_token(user) do
        token
      else
        {:error, cause} ->
          Repo.rollback(cause)
      end
    end)
  end

  def logout(access_token) do
    delete_token(access_token)
  end

  def login(login_data) do
    case Account.get_user_by_email_and_password(login_data) do
      {:ok, user} ->
        create_access_token(user)

      :error ->
        :error
    end
  end

  def fetch_user_by_token(token_string) do
    token = get_token(token_string)

    if token != nil do
      with true <- token_valid?(token),
           user when user != nil <- get_user_by_access_token(token_string) do
        {:ok, user}
      else
        _ ->
          delete_token(token_string)
          :error
      end
    else
      :error
    end
  end

  defp delete_token(token) do
    Repo.delete_all(from AccessToken, where: [token: ^token])
  end

  defp get_token(token) do
    Repo.one(from AccessToken, where: [token: ^token])
  end

  def get_user_by_access_token(access_token) do
    token_query = from AccessToken, where: [token: ^access_token]

    user_query =
      from user in Account.User,
        join: token in subquery(token_query),
        on: token.user_id == user.id

    Repo.one(user_query)
  end

  defp token_valid?(access_token) do
    DateTime.before?(DateTime.utc_now(), access_token.valid_until)
  end

  defp create_access_token(user) do
    Ecto.build_assoc(
      user,
      :access_tokens
    )
    |> AccessToken.changeset(%{
      valid_until: valid_until(),
      token: generate_token()
    })
    |> Repo.insert()
  end

  defp generate_token do
    UUID.uuid4()
  end

  defp valid_until() do
    DateTime.utc_now()
    |> DateTime.add(7, :day)
  end
end
