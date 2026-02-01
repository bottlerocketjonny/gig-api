defmodule GigApiWeb.Schemas.ErrorSchemas do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule ErrorResponse do
    OpenApiSpex.schema(%{
      title: "ErrorResponse",
      description: "Generic error response",
      type: :object,
      properties: %{
        errors: %Schema{
          type: :object,
          properties: %{
            detail: %Schema{type: :string, description: "Error message", example: "Not Found"}
          },
          required: [:detail]
        }
      },
      required: [:errors],
      example: %{
        errors: %{
          detail: "Not Found"
        }
      }
    })
  end

  defmodule ValidationErrorResponse do
    OpenApiSpex.schema(%{
      title: "ValidationErrorResponse",
      description: "Validation error response with field-level errors",
      type: :object,
      properties: %{
        errors: %Schema{
          type: :object,
          description: "Object with field names as keys and arrays of error messages as values",
          additionalProperties: %Schema{
            type: :array,
            items: %Schema{type: :string}
          }
        }
      },
      required: [:errors],
      example: %{
        errors: %{
          name: ["can't be blank"],
          capacity: ["must be greater than 0"],
          venue_type: ["must be one of: pub, club, arena, theatre, outdoor, other"]
        }
      }
    })
  end
end
