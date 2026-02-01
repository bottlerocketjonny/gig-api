defmodule GigApiWeb.VenueJSON do
  alias GigApi.Venues.Venue

  @doc """
  Renders a list of venues.
  """
  def index(%{venues: venues}) do
    %{data: for(venue <- venues, do: data(venue))}
  end

  @doc """
  Renders a single venue.
  """
  def show(%{venue: venue}) do
    %{data: data(venue)}
  end

  defp data(%Venue{} = venue) do
    %{
      id: venue.id,
      name: venue.name,
      city: venue.city,
      capacity: venue.capacity,
      venue_type: venue.venue_type,
      address: venue.address,
      inserted_at: venue.inserted_at,
      updated_at: venue.updated_at
    }
  end
end
