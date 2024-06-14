defmodule PlataWeb.TransactionController do
  use PlataWeb, :controller

  plug PlataWeb.AuthGuard

  def test(conn, _) do
    render(conn, :test, %{})
  end
end
