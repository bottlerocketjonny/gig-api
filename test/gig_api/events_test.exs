defmodule GigApi.EventsTest do
  use GigApi.DataCase

  alias GigApi.Events
  alias GigApi.Events.Event

  import GigApi.Fixtures

  describe "list and get events" do
    test "list_events/0 returns all events with venue" do
      event = event_fixture()
      [listed] = Events.list_events()
      assert listed.id == event.id
      assert listed.venue.id == event.venue.id
    end

    test "get_event/1 returns the event with venue" do
      event = event_fixture()
      assert {:ok, fetched} = Events.get_event(event.id)
      assert fetched.id == event.id
      assert fetched.venue.id == event.venue.id
    end

    test "get_event/1 returns error for non-existent id" do
      assert Events.get_event(999_999) == {:error, :not_found}
    end
  end

  describe "create_event/1" do
    test "creates event with valid attrs" do
      venue = venue_fixture()

      attrs = %{
        name: "Test Gig",
        date: ~D[2024-07-15],
        ticket_price: Decimal.new("25.00"),
        status: "announced",
        venue_id: venue.id
      }

      assert {:ok, %Event{} = event} = Events.create_event(attrs)
      assert event.name == "Test Gig"
      assert event.status == "announced"
      assert event.venue_id == venue.id
    end

    test "returns error with invalid attrs" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(%{})
    end
  end

  describe "update_event/2" do
    test "updates event with valid attrs" do
      event = event_fixture()

      assert {:ok, %Event{} = updated} = Events.update_event(event, %{tickets_sold: 200})
      assert updated.tickets_sold == 200
    end

    test "returns error with invalid attrs" do
      event = event_fixture()

      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, %{status: "invalid"})
    end
  end

  describe "delete_event/1" do
    test "deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert Events.get_event(event.id) == {:error, :not_found}
    end
  end

  describe "search_events/1" do
    test "filters by status" do
      event = event_fixture(%{status: "on_sale"})
      _other = event_fixture(%{status: "announced"})

      results = Events.search_events(%{"status" => "on_sale"})
      assert length(results) == 1
      assert hd(results).id == event.id
    end

    test "filters by city" do
      venue = venue_fixture(%{city: "Sheffield"})
      event = event_fixture(%{venue: venue})

      other_venue = venue_fixture(%{city: "Manchester"})
      _other = event_fixture(%{venue: other_venue})

      results = Events.search_events(%{"city" => "Sheffield"})
      assert length(results) == 1
      assert hd(results).id == event.id
    end

    test "filters by date range" do
      event = event_fixture(%{date: ~D[2024-06-15]})
      _before = event_fixture(%{date: ~D[2024-05-01]})
      _after = event_fixture(%{date: ~D[2024-07-01]})

      results =
        Events.search_events(%{"date_from" => ~D[2024-06-01], "date_to" => ~D[2024-06-30]})

      assert length(results) == 1
      assert hd(results).id == event.id
    end

    test "returns all events with no filters" do
      event1 = event_fixture()
      event2 = event_fixture()

      results = Events.search_events(%{})
      assert length(results) == 2
      ids = Enum.map(results, & &1.id)
      assert event1.id in ids
      assert event2.id in ids
    end
  end

  describe "tonight_events/0" do
    test "returns events happening today" do
      today_event = event_fixture(%{date: Date.utc_today()})
      _tomorrow = event_fixture(%{date: Date.add(Date.utc_today(), 1)})

      results = Events.tonight_events()
      assert length(results) == 1
      assert hd(results).id == today_event.id
    end

    test "returns empty list when no events today" do
      _tomorrow = event_fixture(%{date: Date.add(Date.utc_today(), 1)})

      assert Events.tonight_events() == []
    end
  end

  describe "check_sold_out/1" do
    test "marks event as sold_out when at capacity" do
      venue = venue_fixture(%{capacity: 100})
      event = event_fixture(%{venue: venue, tickets_sold: 100, status: "on_sale"})

      assert {:ok, result} = Events.check_sold_out(event)
      assert result.status == "sold_out"
    end

    test "leaves event unchanged when not at capacity" do
      venue = venue_fixture(%{capacity: 500})
      event = event_fixture(%{venue: venue, tickets_sold: 100})

      {:ok, result} = Events.check_sold_out(event)
      assert result.id == event.id
      assert result.status == "on_sale"
    end
  end
end
