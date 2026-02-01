defmodule GigApi.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses ~w(announced on_sale sold_out cancelled)

  schema "events" do
    field :name, :string
    field :date, :date
    field :ticket_price, :decimal
    field :tickets_sold, :integer, default: 0
    field :status, :string

    belongs_to :venue, GigApi.Venues.Venue

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :date, :ticket_price, :tickets_sold, :status, :venue_id])
    |> validate_required([:name, :date, :ticket_price, :status, :venue_id])
    |> validate_inclusion(:status, @statuses,
      message: "must be one of: #{Enum.join(@statuses, ", ")}"
    )
    |> validate_number(:ticket_price, greater_than_or_equal_to: 0)
    |> validate_number(:tickets_sold, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:venue_id)
  end

  def statuses, do: @statuses
end
