defmodule PlataWeb.InjectUser do
  import Plug.Conn
  alias Plata.Auth

  def init(opts) do
    opts
  end

  def call(conn, _) do
    with {:ok, access_token} <- Map.fetch(conn.req_cookies, "access_token"),
         {:ok, user} <- Auth.fetch_user_by_token(access_token) do
      assign(conn, :user, {:user, user})
    else
      _ -> assign(conn, :user, {:anonymous})
    end
  end
end
