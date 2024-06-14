defmodule PlataWeb.AuthGuard do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _) do
    case Map.fetch(conn.assigns, :user) do
      :error ->
        conn
        |> put_status(401)
        |> halt()

      {:ok, {:anonymous}} ->
        conn
        |> resp(401, "Unauthorized")
        |> send_resp()
        |> halt()

      {:ok, _} ->
        conn
    end
  end
end
