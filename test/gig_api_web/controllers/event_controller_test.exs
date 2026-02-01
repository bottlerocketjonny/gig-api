defmodule GigApiWeb.EventControllerTest do
  use GigApiWeb.ConnCase

  import GigApi.Fixtures

  describe "index" do
    test "lists all events with venue", %{conn: conn} do
      event = event_fixture(%{name: "Test Gig"})
      conn = get(conn, "/api/events")

      assert %{"data" => [event_json]} = json_response(conn, 200)
      assert event_json["id"] == event.id
      assert event_json["name"] == "Test Gig"
      assert event_json["venue"]["id"] == event.venue.id
    end

    test "returns empty list when no events", %{conn: conn} do
      conn = get(conn, "/api/events")
      assert %{"data" => []} = json_response(conn, 200)
    end
  end

  describe "show" do
    test "shows a specific event", %{conn: conn} do
      event = event_fixture(%{name: "My Event"})
      conn = get(conn, "/api/events/#{event.id}")

      assert %{"data" => event_json} = json_response(conn, 200)
      assert event_json["name"] == "My Event"
      assert event_json["venue"] != nil
      assert event_json["tickets_remaining"] != nil
    end

    test "returns 404 for non-existent event", %{conn: conn} do
      conn = get(conn, "/api/events/999999")
      assert json_response(conn, 404)
    end
  end

  describe "create" do
    test "creates event with valid data", %{conn: conn} do
      venue = venue_fixture()

      params = %{
        "event" => %{
          "name" => "New Gig",
          "date" => "2024-07-15",
          "ticket_price" => 25.00,
          "status" => "announced",
          "venue_id" => venue.id
        }
      }

      conn = post(conn, "/api/events", params)
      assert %{"data" => event} = json_response(conn, 201)
      assert event["name"] == "New Gig"
      assert event["status"] == "announced"
    end

    test "returns 422 with invalid data", %{conn: conn} do
      params = %{"event" => %{}}
      conn = post(conn, "/api/events", params)
      assert json_response(conn, 422)
    end
  end

  describe "update" do
    test "updates event with valid data", %{conn: conn} do
      event = event_fixture()

      params = %{"event" => %{"tickets_sold" => 200}}
      conn = put(conn, "/api/events/#{event.id}", params)

      assert %{"data" => updated} = json_response(conn, 200)
      assert updated["tickets_sold"] == 200
    end

    test "returns 404 for non-existent event", %{conn: conn} do
      params = %{"event" => %{"tickets_sold" => 200}}
      conn = put(conn, "/api/events/999999", params)
      assert json_response(conn, 404)
    end
  end

  describe "delete" do
    test "deletes an event", %{conn: conn} do
      event = event_fixture()
      conn = delete(conn, "/api/events/#{event.id}")
      assert response(conn, 204)
    end
  end

  describe "tonight" do
    test "returns events happening today", %{conn: conn} do
      event = event_fixture(%{date: Date.utc_today()})
      _tomorrow = event_fixture(%{date: Date.add(Date.utc_today(), 1)})

      conn = get(conn, "/api/events/tonight")

      assert %{"data" => [event_json]} = json_response(conn, 200)
      assert event_json["id"] == event.id
    end
  end

  describe "search" do
    test "filters events by city", %{conn: conn} do
      venue = venue_fixture(%{city: "Sheffield"})
      event = event_fixture(%{venue: venue})

      other_venue = venue_fixture(%{city: "Manchester"})
      _other = event_fixture(%{venue: other_venue})

      conn = get(conn, "/api/search/events", %{"city" => "Sheffield"})

      assert %{"data" => [event_json]} = json_response(conn, 200)
      assert event_json["id"] == event.id
    end

    test "filters events by status", %{conn: conn} do
      event = event_fixture(%{status: "on_sale"})
      _other = event_fixture(%{status: "announced"})

      conn = get(conn, "/api/search/events", %{"status" => "on_sale"})

      assert %{"data" => [event_json]} = json_response(conn, 200)
      assert event_json["id"] == event.id
    end
  end
end
