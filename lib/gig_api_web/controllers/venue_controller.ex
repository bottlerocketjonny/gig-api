defmodule GigApiWeb.VenueController do
  use GigApiWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias GigApi.Venues
  alias GigApi.Venues.Venue
  alias GigApiWeb.Schemas.VenueSchemas

  action_fallback GigApiWeb.FallbackController

  tags(["Venues"])

  operation(:index,
    summary: "List all venues",
    description: "Returns a list of all venues in the system",
    responses: [
      ok: {"Venues list", "application/json", VenueSchemas.VenuesResponse}
    ]
  )

  def index(conn, _params) do
    venues = Venues.list_venues()
    render(conn, :index, venues: venues)
  end

  operation(:show,
    summary: "Get a venue",
    description: "Returns a single venue by ID",
    parameters: [
      id: [
        in: :path,
        type: :integer,
        description: "Venue ID",
        required: true,
        example: 1
      ]
    ],
    responses: [
      ok: {"Venue", "application/json", VenueSchemas.VenueResponse},
      not_found: {"Not Found", "application/json", GigApiWeb.Schemas.ErrorSchemas.ErrorResponse}
    ]
  )

  def show(conn, %{"id" => id}) do
    with {:ok, %Venue{} = venue} <- Venues.get_venue(id) do
      render(conn, :show, venue: venue)
    end
  end

  operation(:create,
    summary: "Create a venue",
    description: "Creates a new venue with the given attributes",
    request_body: {"Venue params", "application/json", VenueSchemas.VenueRequest},
    responses: [
      created: {"Created venue", "application/json", VenueSchemas.VenueResponse},
      unprocessable_entity:
        {"Validation errors", "application/json",
         GigApiWeb.Schemas.ErrorSchemas.ValidationErrorResponse}
    ]
  )

  def create(conn, %{"venue" => venue_params}) do
    with {:ok, %Venue{} = venue} <- Venues.create_venue(venue_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/venues/#{venue}")
      |> render(:show, venue: venue)
    end
  end

  operation(:update,
    summary: "Update a venue",
    description: "Updates an existing venue with the given attributes",
    parameters: [
      id: [
        in: :path,
        type: :integer,
        description: "Venue ID",
        required: true,
        example: 1
      ]
    ],
    request_body: {"Venue params", "application/json", VenueSchemas.VenueRequest},
    responses: [
      ok: {"Updated venue", "application/json", VenueSchemas.VenueResponse},
      not_found: {"Not Found", "application/json", GigApiWeb.Schemas.ErrorSchemas.ErrorResponse},
      unprocessable_entity:
        {"Validation errors", "application/json",
         GigApiWeb.Schemas.ErrorSchemas.ValidationErrorResponse}
    ]
  )

  def update(conn, %{"id" => id, "venue" => venue_params}) do
    with {:ok, %Venue{} = venue} <- Venues.get_venue(id),
         {:ok, %Venue{} = venue} <- Venues.update_venue(venue, venue_params) do
      render(conn, :show, venue: venue)
    end
  end

  operation(:delete,
    summary: "Delete a venue",
    description: "Deletes an existing venue",
    parameters: [
      id: [
        in: :path,
        type: :integer,
        description: "Venue ID",
        required: true,
        example: 1
      ]
    ],
    responses: [
      no_content: "Deleted",
      not_found: {"Not Found", "application/json", GigApiWeb.Schemas.ErrorSchemas.ErrorResponse}
    ]
  )

  def delete(conn, %{"id" => id}) do
    with {:ok, %Venue{} = venue} <- Venues.get_venue(id),
         {:ok, %Venue{}} <- Venues.delete_venue(venue) do
      send_resp(conn, :no_content, "")
    end
  end
end
