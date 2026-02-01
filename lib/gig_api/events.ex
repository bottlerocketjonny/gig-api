defmodule GigApi.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias GigApi.Repo
  alias GigApi.Events.Event

  @doc """
  Returns the list of events with preloaded venue.
  """
  def list_events do
    Event
    |> preload(:venue)
    |> Repo.all()
  end

  @doc """
  Gets a single event with preloaded venue.

  Returns `{:ok, event}` if found, `{:error, :not_found}` otherwise.
  """
  def get_event(id) do
    case Repo.get(Event, id) do
      nil -> {:error, :not_found}
      event -> {:ok, Repo.preload(event, :venue)}
    end
  end

  @doc """
  Gets a single event. Raises if not found.
  """
  def get_event!(id) do
    Event
    |> Repo.get!(id)
    |> Repo.preload(:venue)
  end

  @doc """
  Creates an event.
  """
  def create_event(attrs \\ %{}) do
    %Event{} |> Event.changeset(attrs) |> Repo.insert()
  end

  @doc """
  Updates an event.
  """
  def update_event(%Event{} = event, attrs) do
    event |> Event.changeset(attrs) |> Repo.update()
  end

  @doc """
  Deletes an event.
  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.
  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  @doc """
  Searches events with optional filters.

  Params:
  - "city" - filter by venue city
  - "status" - filter by event status
  - "date_from" - events on or after this date
  - "date_to" - events on or before this date
  """
  def search_events(params) do
    Event
    |> maybe_filter_by_status(params)
    |> maybe_filter_by_city(params)
    |> maybe_filter_by_date_from(params)
    |> maybe_filter_by_date_to(params)
    |> preload(:venue)
    |> Repo.all()
  end

  @doc """
  Returns all events happening today.
  """
  def tonight_events do
    from(e in Event, where: e.date == ^Date.utc_today(), preload: :venue)
    |> Repo.all()
  end

  @doc """
  Checks if an event is sold out and updates status if needed.
  """
  def check_sold_out(%Event{} = event) do
    event = Repo.preload(event, :venue)

    if event.tickets_sold >= event.venue.capacity do
      update_event(event, %{status: "sold_out"})
    else
      {:ok, event}
    end
  end

  defp maybe_filter_by_status(query, %{"status" => status}) do
    from e in query, where: e.status == ^status
  end

  defp maybe_filter_by_status(query, _params), do: query

  defp maybe_filter_by_city(query, %{"city" => city}) do
    from e in query, join: v in assoc(e, :venue), where: v.city == ^city
  end

  defp maybe_filter_by_city(query, _params), do: query

  defp maybe_filter_by_date_from(query, %{"date_from" => date_from}) do
    from e in query, where: e.date >= ^date_from
  end

  defp maybe_filter_by_date_from(query, _params), do: query

  defp maybe_filter_by_date_to(query, %{"date_to" => date_to}) do
    from e in query, where: e.date <= ^date_to
  end

  defp maybe_filter_by_date_to(query, _params), do: query
end
