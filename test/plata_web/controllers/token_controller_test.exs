defmodule PlataWeb.TokenControllerTest do
  use PlataWeb.ConnCase

  import Plata.AuthFixtures

  alias Plata.Auth.Token

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all access_tokens", %{conn: conn} do
      conn = get(conn, ~p"/api/access_tokens")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create token" do
    test "renders token when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/access_tokens", token: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/access_tokens/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/access_tokens", token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update token" do
    setup [:create_token]

    test "renders token when data is valid", %{conn: conn, token: %Token{id: id} = token} do
      conn = put(conn, ~p"/api/access_tokens/#{token}", token: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/access_tokens/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, token: token} do
      conn = put(conn, ~p"/api/access_tokens/#{token}", token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete token" do
    setup [:create_token]

    test "deletes chosen token", %{conn: conn, token: token} do
      conn = delete(conn, ~p"/api/access_tokens/#{token}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/access_tokens/#{token}")
      end
    end
  end

  defp create_token(_) do
    token = token_fixture()
    %{token: token}
  end
end
