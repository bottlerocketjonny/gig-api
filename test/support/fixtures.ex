defmodule GigApi.Fixtures do
  @moduledoc """
  Test helpers for creating entities.
  """

  alias GigApi.Repo
  alias GigApi.Events.Event

  @doc """
  Generate a venue.
  """
  def venue_fixture(attrs \\ %{}) do
    {:ok, venue} =
      attrs
      |> Enum.into(%{
        name: "Test Venue #{System.unique_integer([:positive])}",
        city: "Sheffield",
        capacity: 500,
        venue_type: "club",
        address: "123 Test Street"
      })
      |> GigApi.Venues.create_venue()

    venue
  end

  @doc """
  Generate an event.
  Creates a venue if not provided.
  """
  def event_fixture(attrs \\ %{}) do
    venue = attrs[:venue] || venue_fixture()

    event_attrs =
      attrs
      |> Map.drop([:venue])
      |> Enum.into(%{
        name: "Test Event #{System.unique_integer([:positive])}",
        date: Date.utc_today(),
        ticket_price: Decimal.new("25.00"),
        tickets_sold: 100,
        status: "on_sale",
        venue_id: venue.id
      })

    # Direct insert since create_event is a TODO
    %Event{}
    |> Event.changeset(event_attrs)
    |> Repo.insert!()
    |> Repo.preload(:venue)
  end
end
