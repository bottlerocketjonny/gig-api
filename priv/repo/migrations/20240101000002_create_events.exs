defmodule GigApi.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :date, :date, null: false
      add :ticket_price, :decimal, null: false, precision: 10, scale: 2
      add :tickets_sold, :integer, null: false, default: 0
      add :status, :string, null: false
      add :venue_id, references(:venues, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:events, [:venue_id])
    create index(:events, [:date])
    create index(:events, [:status])
  end
end
