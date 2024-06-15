defmodule Plata.Repo do
  use Ecto.Repo,
    otp_app: :plata,
    adapter: Ecto.Adapters.Postgres,
    ssl_opts: [verify: :verify_none]
end
