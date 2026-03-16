defmodule GigApi.Venues do
  @moduledoc """
  The Venues context.
  """

  import Ecto.Query, warn: false
  alias GigApi.Repo
  alias GigApi.Venues.Venue

  def list_venues do
    Repo.all(Venue)
  end

  def get_venue(id) do
    case Repo.get(Venue, id) do
      nil -> {:error, :not_found}
      venue -> {:ok, venue}
    end
  end

  def create_venue(attrs \\ %{}) do
    %Venue{}
    |> Venue.changeset(attrs)
    |> Repo.insert()
  end

  def update_venue(%Venue{} = venue, attrs) do
    venue
    |> Venue.changeset(attrs)
    |> Repo.update()
  end

  def delete_venue(%Venue{} = venue) do
    Repo.delete(venue)
  end
end
