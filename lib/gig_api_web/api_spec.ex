defmodule GigApiWeb.ApiSpec do
  @moduledoc """
  OpenAPI specification for the Gig API.
  """

  alias OpenApiSpex.{Info, OpenApi, Paths, Server}
  alias GigApiWeb.Router
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        %Server{url: "http://localhost:4000", description: "Local development server"}
      ],
      info: %Info{
        title: "Gig API",
        description: """
        A Phoenix API for discovering live music events and venues in Sheffield.

        This API provides endpoints for:
        - **Venues**: Manage music venues with capacity and type information
        - **Events**: Browse and search upcoming gigs with ticket availability
        """,
        version: "1.0.0"
      },
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
