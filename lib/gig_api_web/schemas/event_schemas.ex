defmodule GigApiWeb.Schemas.EventSchemas do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule EmbeddedVenue do
    OpenApiSpex.schema(%{
      title: "EmbeddedVenue",
      description: "Venue info embedded in event",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, example: 1},
        name: %Schema{type: :string, example: "The Leadmill"},
        city: %Schema{type: :string, example: "Sheffield"},
        capacity: %Schema{type: :integer, example: 900},
        venue_type: %Schema{type: :string, example: "club"}
      },
      nullable: true
    })
  end

  defmodule Event do
    OpenApiSpex.schema(%{
      title: "Event",
      description: "A music event",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, example: 1},
        name: %Schema{type: :string, example: "Arctic Monkeys Live"},
        date: %Schema{type: :string, format: :date, example: "2024-07-15"},
        ticket_price: %Schema{type: :string, example: "25.00"},
        tickets_sold: %Schema{type: :integer, example: 450},
        status: %Schema{
          type: :string,
          enum: ["announced", "on_sale", "sold_out", "cancelled"],
          example: "on_sale"
        },
        venue: EmbeddedVenue,
        tickets_remaining: %Schema{type: :integer, example: 450, nullable: true},
        inserted_at: %Schema{type: :string, format: :"date-time"},
        updated_at: %Schema{type: :string, format: :"date-time"}
      },
      required: [:id, :name, :date, :ticket_price, :tickets_sold, :status]
    })
  end

  defmodule EventRequest do
    OpenApiSpex.schema(%{
      title: "EventRequest",
      description: "Request body for creating/updating an event",
      type: :object,
      properties: %{
        event: %Schema{
          type: :object,
          properties: %{
            name: %Schema{type: :string, example: "Arctic Monkeys Live"},
            date: %Schema{type: :string, format: :date, example: "2024-07-15"},
            ticket_price: %Schema{type: :number, example: 25.00},
            tickets_sold: %Schema{type: :integer, example: 0, default: 0},
            status: %Schema{
              type: :string,
              enum: ["announced", "on_sale", "sold_out", "cancelled"],
              example: "announced"
            },
            venue_id: %Schema{type: :integer, example: 1}
          },
          required: [:name, :date, :ticket_price, :status, :venue_id]
        }
      },
      required: [:event],
      example: %{
        event: %{
          name: "Arctic Monkeys Live",
          date: "2024-07-15",
          ticket_price: 25.00,
          status: "announced",
          venue_id: 1
        }
      }
    })
  end

  defmodule EventResponse do
    OpenApiSpex.schema(%{
      title: "EventResponse",
      description: "Single event response",
      type: :object,
      properties: %{data: Event},
      required: [:data]
    })
  end

  defmodule EventsResponse do
    OpenApiSpex.schema(%{
      title: "EventsResponse",
      description: "List of events response",
      type: :object,
      properties: %{data: %Schema{type: :array, items: Event}},
      required: [:data]
    })
  end
end
