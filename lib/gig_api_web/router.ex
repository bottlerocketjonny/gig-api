defmodule GigApiWeb.Router do
  use GigApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: GigApiWeb.ApiSpec
  end

  scope "/api", GigApiWeb do
    pipe_through :api

    resources "/venues", VenueController, except: [:new, :edit]

    get "/events/tonight", EventController, :tonight
    get "/search/events", EventController, :search
    resources "/events", EventController, except: [:new, :edit]
  end

  scope "/" do
    pipe_through :api
    get "/api/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/swaggerui" do
    get "/", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end
end
