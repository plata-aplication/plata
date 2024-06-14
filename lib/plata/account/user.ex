defmodule Plata.Account.User do
  alias __MODULE__
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  schema "users" do
    field :name, :string
    field :password, :string
    field :email, :string
    field :repeat_password, :string, virtual: true
    has_many :access_tokens, Plata.Auth.AccessToken

    timestamps(type: :utc_datetime)
  end

  def validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_length(:email, min: 5, max: 60)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def validate_name(changeset) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 60)
    |> unique_constraint(:name)
  end

  def validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 60)
    |> validate_repeat_password()
    |> maybe_hash_password()
  end

  def valid_password?(%User{password: password}, password_to_check) do
    Bcrypt.verify_pass(password_to_check, password)
  end

  def validate_repeat_password(changeset) do
    password = get_change(changeset, :password)
    password_repeat = get_change(changeset, :repeat_password)

    if password != password_repeat do
      add_error(changeset, :password, "Password and repeat password are not the same",
        validation: "repeat_password"
      )
    else
      delete_change(changeset, :repeat_password)
    end
  end

  def maybe_hash_password(changeset) do
    password = get_change(changeset, :password)

    if password != nil do
      put_change(changeset, :password, Bcrypt.hash_pwd_salt(password))
    else
      changeset
    end
  end

  @doc false
  def register_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :name, :repeat_password])
    |> validate_email()
    |> validate_name()
    |> validate_password()
  end
end
