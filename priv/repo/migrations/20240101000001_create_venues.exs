defmodule GigApi.Repo.Migrations.CreateVenues do
  use Ecto.Migration

  def change do
    create table(:venues) do
      add :name, :string, null: false
      add :city, :string, null: false
      add :capacity, :integer, null: false
      add :venue_type, :string, null: false
      add :address, :string

      timestamps(type: :utc_datetime)
    end

    create index(:venues, [:city])
    create index(:venues, [:venue_type])
  end
end
