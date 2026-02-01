defmodule GigApi.Venues.Venue do
  use Ecto.Schema
  import Ecto.Changeset

  @venue_types ~w(pub club arena theatre outdoor other)

  schema "venues" do
    field :name, :string
    field :city, :string
    field :capacity, :integer
    field :venue_type, :string
    field :address, :string

    has_many :events, GigApi.Events.Event

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(venue, attrs) do
    venue
    |> cast(attrs, [:name, :city, :capacity, :venue_type, :address])
    |> validate_required([:name, :city, :capacity, :venue_type])
    |> validate_inclusion(:venue_type, @venue_types,
      message: "must be one of: #{Enum.join(@venue_types, ", ")}"
    )
    |> validate_number(:capacity, greater_than: 0)
  end

  def venue_types, do: @venue_types
end
