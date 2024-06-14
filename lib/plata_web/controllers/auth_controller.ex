defmodule PlataWeb.AuthController do
  use PlataWeb, :controller

  alias Plata.Auth

  action_fallback PlataWeb.FallbackController

  def register(conn, params) do
    case Auth.register(params) do
      {:ok, token} ->
        conn
        |> put_resp_cookie("access_token", token.token)
        |> render(:data, token: token)

      {:error, %Ecto.Changeset{errors: errors}} ->
        IO.inspect(errors)

        conn
        |> put_status(422)
        |> render(:validation_error, errors: errors)
    end
  end

  def logout(conn, _params) do
    case Map.get(conn.assigns, :user) do
      {:anonymous} ->
        conn
        |> put_status(200)
        |> render(:logout_success)

      {:user, _} ->
        {:ok, access_token} = Map.fetch(conn.req_cookies, "access_token")
        Auth.logout(access_token)

        conn
        |> delete_resp_cookie("access_token")
        |> put_status(200)
        |> render(:logout_success)
    end
  end

  def login(conn, params) do
    case Auth.login(params) do
      {:ok, token} ->
        conn
        |> put_resp_cookie("access_token", token.token)
        |> render(:data, token: token)

      :error ->
        conn
        |> put_status(403)
        |> render(:login_error, error: "Incorrect email or password")
    end
  end

  def me(conn, _params) do
    case Map.get(conn.assigns, :user) do
      {:user, user} ->
        render(conn, :user, user: user)

      {:anonymous} ->
        render(conn, :anonymous)

      nil ->
        render(conn, :anonymous)
    end
  end
end
