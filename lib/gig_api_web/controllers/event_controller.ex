defmodule GigApiWeb.EventController do
  use GigApiWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias GigApi.Events
  alias GigApi.Events.Event
  alias GigApiWeb.Schemas.EventSchemas

  action_fallback GigApiWeb.FallbackController

  tags(["Events"])

  operation(:index,
    summary: "List all events",
    description: "Returns all events with their venue information",
    responses: [
      ok: {"Events list", "application/json", EventSchemas.EventsResponse}
    ]
  )

  def index(conn, _params) do
    events = Events.list_events()
    render(conn, :index, events: events)
  end

  operation(:show,
    summary: "Get an event",
    description: "Returns a single event by ID",
    parameters: [
      id: [in: :path, type: :integer, description: "Event ID", required: true]
    ],
    responses: [
      ok: {"Event", "application/json", EventSchemas.EventResponse},
      not_found: {"Not Found", "application/json", GigApiWeb.Schemas.ErrorSchemas.ErrorResponse}
    ]
  )

  def show(conn, %{"id" => id}) do
    with {:ok, %Event{} = event} <- Events.get_event(id) do
      render(conn, :show, event: event)
    end
  end

  operation(:create,
    summary: "Create an event",
    description: "Creates a new event with venue association",
    request_body: {"Event params", "application/json", EventSchemas.EventRequest},
    responses: [
      created: {"Created event", "application/json", EventSchemas.EventResponse},
      unprocessable_entity:
        {"Validation errors", "application/json",
         GigApiWeb.Schemas.ErrorSchemas.ValidationErrorResponse}
    ]
  )

  def create(conn, %{"event" => event_params}) do
    with {:ok, %Event{} = event} <- Events.create_event(event_params) do
      event = GigApi.Repo.preload(event, :venue)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/events/#{event}")
      |> render(:show, event: event)
    end
  end

  operation(:update,
    summary: "Update an event",
    description: "Updates an existing event",
    parameters: [
      id: [in: :path, type: :integer, description: "Event ID", required: true]
    ],
    request_body: {"Event params", "application/json", EventSchemas.EventRequest},
    responses: [
      ok: {"Updated event", "application/json", EventSchemas.EventResponse},
      not_found: {"Not Found", "application/json", GigApiWeb.Schemas.ErrorSchemas.ErrorResponse},
      unprocessable_entity:
        {"Validation errors", "application/json",
         GigApiWeb.Schemas.ErrorSchemas.ValidationErrorResponse}
    ]
  )

  def update(conn, %{"id" => id, "event" => event_params}) do
    with {:ok, %Event{} = event} <- Events.get_event(id),
         {:ok, %Event{} = event} <- Events.update_event(event, event_params) do
      event = GigApi.Repo.preload(event, :venue)
      render(conn, :show, event: event)
    end
  end

  operation(:delete,
    summary: "Delete an event",
    description: "Deletes an event",
    parameters: [
      id: [in: :path, type: :integer, description: "Event ID", required: true]
    ],
    responses: [
      no_content: "Deleted",
      not_found: {"Not Found", "application/json", GigApiWeb.Schemas.ErrorSchemas.ErrorResponse}
    ]
  )

  def delete(conn, %{"id" => id}) do
    with {:ok, %Event{} = event} <- Events.get_event(id),
         {:ok, %Event{}} <- Events.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end

  operation(:tonight,
    summary: "Tonight's events",
    description: "Returns all events happening today",
    responses: [
      ok: {"Tonight's events", "application/json", EventSchemas.EventsResponse}
    ]
  )

  def tonight(conn, _params) do
    events = Events.tonight_events()
    render(conn, :index, events: events)
  end

  operation(:search,
    summary: "Search events",
    description: "Search events with optional filters for city, status, and date range",
    parameters: [
      city: [in: :query, type: :string, description: "Filter by venue city", required: false],
      status: [
        in: :query,
        schema: %OpenApiSpex.Schema{
          type: :string,
          enum: ["announced", "on_sale", "sold_out", "cancelled"]
        },
        description: "Filter by status",
        required: false
      ],
      date_from: [
        in: :query,
        type: :string,
        description: "Events on or after (YYYY-MM-DD)",
        required: false
      ],
      date_to: [
        in: :query,
        type: :string,
        description: "Events on or before (YYYY-MM-DD)",
        required: false
      ]
    ],
    responses: [
      ok: {"Search results", "application/json", EventSchemas.EventsResponse}
    ]
  )

  def search(conn, params) do
    events = Events.search_events(params)
    render(conn, :index, events: events)
  end
end
