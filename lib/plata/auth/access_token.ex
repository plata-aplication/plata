defmodule Plata.Auth.AccessToken do
  alias Plata.Account
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:token, :string, autogenerate: false}

  schema "access_tokens" do
    field :valid_until, :utc_datetime
    belongs_to :user, Account.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(access_token, attrs) do
    access_token
    |> cast(attrs, [:valid_until, :token])
    |> validate_required([:valid_until, :token])
  end
end
