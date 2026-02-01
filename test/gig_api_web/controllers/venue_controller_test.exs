defmodule GigApiWeb.VenueControllerTest do
  use GigApiWeb.ConnCase

  import GigApi.Fixtures

  @create_attrs %{
    "venue" => %{
      "name" => "Test Venue",
      "city" => "Sheffield",
      "capacity" => 500,
      "venue_type" => "club",
      "address" => "123 Test St"
    }
  }

  @update_attrs %{
    "venue" => %{
      "name" => "Updated Venue",
      "capacity" => 600
    }
  }

  @invalid_attrs %{
    "venue" => %{
      "name" => nil,
      "city" => nil,
      "capacity" => nil,
      "venue_type" => nil
    }
  }

  describe "index" do
    test "lists all venues", %{conn: conn} do
      venue_fixture()
      conn = get(conn, "/api/venues")
      assert %{"data" => [_venue]} = json_response(conn, 200)
    end

    test "returns empty list when no venues exist", %{conn: conn} do
      conn = get(conn, "/api/venues")
      assert %{"data" => []} = json_response(conn, 200)
    end
  end

  describe "show" do
    test "shows a specific venue", %{conn: conn} do
      venue = venue_fixture(%{name: "The Leadmill"})
      conn = get(conn, "/api/venues/#{venue.id}")

      assert %{
               "data" => %{
                 "id" => _,
                 "name" => "The Leadmill",
                 "city" => "Sheffield"
               }
             } = json_response(conn, 200)
    end

    test "returns 404 for non-existent venue", %{conn: conn} do
      conn = get(conn, "/api/venues/999999")
      assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end
  end

  describe "create" do
    test "creates venue with valid data", %{conn: conn} do
      conn = post(conn, "/api/venues", @create_attrs)
      assert %{"data" => %{"id" => id}} = json_response(conn, 201)

      conn = get(conn, "/api/venues/#{id}")
      assert %{"data" => %{"name" => "Test Venue"}} = json_response(conn, 200)
    end

    test "returns validation errors with invalid data", %{conn: conn} do
      conn = post(conn, "/api/venues", @invalid_attrs)
      assert %{"errors" => errors} = json_response(conn, 422)
      assert Map.has_key?(errors, "name")
    end
  end

  describe "update" do
    test "updates venue with valid data", %{conn: conn} do
      venue = venue_fixture()
      conn = put(conn, "/api/venues/#{venue.id}", @update_attrs)

      assert %{"data" => %{"name" => "Updated Venue", "capacity" => 600}} =
               json_response(conn, 200)
    end

    test "returns 404 for non-existent venue", %{conn: conn} do
      conn = put(conn, "/api/venues/999999", @update_attrs)
      assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end
  end

  describe "delete" do
    test "deletes a venue", %{conn: conn} do
      venue = venue_fixture()
      conn = delete(conn, "/api/venues/#{venue.id}")
      assert response(conn, 204)

      conn = get(conn, "/api/venues/#{venue.id}")
      assert json_response(conn, 404)
    end

    test "returns 404 for non-existent venue", %{conn: conn} do
      conn = delete(conn, "/api/venues/999999")
      assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end
  end
end
