defmodule Plata.Repo.Migrations.CreateAccessTokens do
  use Ecto.Migration

  def change do
    create table(:access_tokens, primary_key: false) do
      add :valid_until, :utc_datetime
      add :token, :string, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:access_tokens, [:user_id])
  end
end
