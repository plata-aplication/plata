defmodule Plata.Repo do
  use Ecto.Repo,
    otp_app: :plata,
    adapter: Ecto.Adapters.Postgres
end
