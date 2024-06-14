defmodule Plata.AuthTest do
  use Plata.DataCase

  alias Plata.Auth

  describe "access_tokens" do
    alias Plata.Auth.AccessToken

    import Plata.AuthFixtures

    @invalid_attrs %{token: nil, valid_until: nil}

    test "list_access_tokens/0 returns all access_tokens" do
      access_token = access_token_fixture()
      assert Auth.list_access_tokens() == [access_token]
    end

    test "get_access_token!/1 returns the access_token with given id" do
      access_token = access_token_fixture()
      assert Auth.get_access_token!(access_token.id) == access_token
    end

    test "create_access_token/1 with valid data creates a access_token" do
      valid_attrs = %{token: "some token", valid_until: ~U[2024-06-05 20:20:00Z]}

      assert {:ok, %AccessToken{} = access_token} = Auth.create_access_token(valid_attrs)
      assert access_token.token == "some token"
      assert access_token.valid_until == ~U[2024-06-05 20:20:00Z]
    end

    test "create_access_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_access_token(@invalid_attrs)
    end

    test "update_access_token/2 with valid data updates the access_token" do
      access_token = access_token_fixture()
      update_attrs = %{token: "some updated token", valid_until: ~U[2024-06-06 20:20:00Z]}

      assert {:ok, %AccessToken{} = access_token} = Auth.update_access_token(access_token, update_attrs)
      assert access_token.token == "some updated token"
      assert access_token.valid_until == ~U[2024-06-06 20:20:00Z]
    end

    test "update_access_token/2 with invalid data returns error changeset" do
      access_token = access_token_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_access_token(access_token, @invalid_attrs)
      assert access_token == Auth.get_access_token!(access_token.id)
    end

    test "delete_access_token/1 deletes the access_token" do
      access_token = access_token_fixture()
      assert {:ok, %AccessToken{}} = Auth.delete_access_token(access_token)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_access_token!(access_token.id) end
    end

    test "change_access_token/1 returns a access_token changeset" do
      access_token = access_token_fixture()
      assert %Ecto.Changeset{} = Auth.change_access_token(access_token)
    end
  end
end
