defmodule Plata.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Plata.Account` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user name.
  """
  def unique_user_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        name: unique_user_name(),
        password: "some password"
      })
      |> Plata.Account.create_user()

    user
  end
end
