defmodule Plata.AuthFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Plata.Auth` context.
  """

  @doc """
  Generate a access_token.
  """
  def access_token_fixture(attrs \\ %{}) do
    {:ok, access_token} =
      attrs
      |> Enum.into(%{
        token: "some token",
        valid_until: ~U[2024-06-05 20:20:00Z]
      })
      |> Plata.Auth.create_access_token()

    access_token
  end
end
