defmodule GigApiWeb.EventJSON do
  alias GigApi.Events.Event
  alias GigApi.Venues.Venue

  @doc """
  Renders a list of events.
  """
  def index(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
  end

  @doc """
  Renders a single event.
  """
  def show(%{event: event}) do
    %{data: data(event)}
  end

  defp data(%Event{} = event) do
    %{
      id: event.id,
      name: event.name,
      date: event.date,
      ticket_price: event.ticket_price,
      tickets_sold: event.tickets_sold,
      status: event.status,
      venue: venue_data(event.venue),
      tickets_remaining: tickets_remaining(event),
      inserted_at: event.inserted_at,
      updated_at: event.updated_at
    }
  end

  defp venue_data(%Venue{} = venue) do
    %{
      id: venue.id,
      name: venue.name,
      city: venue.city,
      capacity: venue.capacity,
      venue_type: venue.venue_type
    }
  end

  defp venue_data(_), do: nil

  defp tickets_remaining(%Event{venue: %Venue{} = venue} = event) do
    max(0, venue.capacity - event.tickets_sold)
  end

  defp tickets_remaining(_event), do: nil
end
