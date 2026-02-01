defmodule GigApiWeb.Schemas.VenueSchemas do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule Venue do
    OpenApiSpex.schema(%{
      title: "Venue",
      description: "A music venue",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Venue ID", example: 1},
        name: %Schema{type: :string, description: "Venue name", example: "The Leadmill"},
        city: %Schema{
          type: :string,
          description: "City where the venue is located",
          example: "Sheffield"
        },
        capacity: %Schema{type: :integer, description: "Maximum capacity", example: 900},
        venue_type: %Schema{
          type: :string,
          description: "Type of venue",
          enum: ["pub", "club", "arena", "theatre", "outdoor", "other"],
          example: "club"
        },
        address: %Schema{
          type: :string,
          description: "Street address",
          example: "6 Leadmill Rd",
          nullable: true
        },
        inserted_at: %Schema{
          type: :string,
          format: :"date-time",
          description: "Creation timestamp"
        },
        updated_at: %Schema{
          type: :string,
          format: :"date-time",
          description: "Last update timestamp"
        }
      },
      required: [:id, :name, :city, :capacity, :venue_type],
      example: %{
        id: 1,
        name: "The Leadmill",
        city: "Sheffield",
        capacity: 900,
        venue_type: "club",
        address: "6 Leadmill Rd",
        inserted_at: "2024-01-15T10:00:00Z",
        updated_at: "2024-01-15T10:00:00Z"
      }
    })
  end

  defmodule VenueRequest do
    OpenApiSpex.schema(%{
      title: "VenueRequest",
      description: "Request body for creating or updating a venue",
      type: :object,
      properties: %{
        venue: %Schema{
          type: :object,
          properties: %{
            name: %Schema{type: :string, description: "Venue name", example: "The Leadmill"},
            city: %Schema{type: :string, description: "City", example: "Sheffield"},
            capacity: %Schema{type: :integer, description: "Maximum capacity", example: 900},
            venue_type: %Schema{
              type: :string,
              description: "Type of venue",
              enum: ["pub", "club", "arena", "theatre", "outdoor", "other"],
              example: "club"
            },
            address: %Schema{
              type: :string,
              description: "Street address",
              example: "6 Leadmill Rd"
            }
          },
          required: [:name, :city, :capacity, :venue_type]
        }
      },
      required: [:venue],
      example: %{
        venue: %{
          name: "The Leadmill",
          city: "Sheffield",
          capacity: 900,
          venue_type: "club",
          address: "6 Leadmill Rd"
        }
      }
    })
  end

  defmodule VenueResponse do
    OpenApiSpex.schema(%{
      title: "VenueResponse",
      description: "Response containing a single venue",
      type: :object,
      properties: %{
        data: Venue
      },
      required: [:data]
    })
  end

  defmodule VenuesResponse do
    OpenApiSpex.schema(%{
      title: "VenuesResponse",
      description: "Response containing a list of venues",
      type: :object,
      properties: %{
        data: %Schema{type: :array, items: Venue}
      },
      required: [:data]
    })
  end
end
