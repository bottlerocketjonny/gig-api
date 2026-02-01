defmodule GigApi.VenuesTest do
  use GigApi.DataCase

  alias GigApi.Venues
  alias GigApi.Venues.Venue

  import GigApi.Fixtures

  describe "venues" do
    @valid_attrs %{
      name: "The Leadmill",
      city: "Sheffield",
      capacity: 900,
      venue_type: "club",
      address: "6 Leadmill Rd"
    }
    @update_attrs %{
      name: "The New Leadmill",
      capacity: 1000
    }
    @invalid_attrs %{name: nil, city: nil, capacity: nil, venue_type: nil}

    test "list_venues/0 returns all venues" do
      venue = venue_fixture()
      assert Venues.list_venues() == [venue]
    end

    test "get_venue/1 returns the venue with given id" do
      venue = venue_fixture()
      assert Venues.get_venue(venue.id) == {:ok, venue}
    end

    test "get_venue/1 returns error for non-existent id" do
      assert Venues.get_venue(999_999) == {:error, :not_found}
    end

    test "create_venue/1 with valid data creates a venue" do
      assert {:ok, %Venue{} = venue} = Venues.create_venue(@valid_attrs)
      assert venue.name == "The Leadmill"
      assert venue.city == "Sheffield"
      assert venue.capacity == 900
      assert venue.venue_type == "club"
      assert venue.address == "6 Leadmill Rd"
    end

    test "create_venue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Venues.create_venue(@invalid_attrs)
    end

    test "create_venue/1 with invalid venue_type returns error changeset" do
      attrs = Map.put(@valid_attrs, :venue_type, "invalid")
      assert {:error, %Ecto.Changeset{} = changeset} = Venues.create_venue(attrs)

      assert "must be one of: pub, club, arena, theatre, outdoor, other" in errors_on(changeset).venue_type
    end

    test "create_venue/1 with negative capacity returns error changeset" do
      attrs = Map.put(@valid_attrs, :capacity, -1)
      assert {:error, %Ecto.Changeset{} = changeset} = Venues.create_venue(attrs)
      assert "must be greater than 0" in errors_on(changeset).capacity
    end

    test "update_venue/2 with valid data updates the venue" do
      venue = venue_fixture()
      assert {:ok, %Venue{} = venue} = Venues.update_venue(venue, @update_attrs)
      assert venue.name == "The New Leadmill"
      assert venue.capacity == 1000
    end

    test "update_venue/2 with invalid data returns error changeset" do
      venue = venue_fixture()
      assert {:error, %Ecto.Changeset{}} = Venues.update_venue(venue, @invalid_attrs)
      assert Venues.get_venue(venue.id) == {:ok, venue}
    end

    test "delete_venue/1 deletes the venue" do
      venue = venue_fixture()
      assert {:ok, %Venue{}} = Venues.delete_venue(venue)
      assert Venues.get_venue(venue.id) == {:error, :not_found}
    end

    test "change_venue/1 returns a venue changeset" do
      venue = venue_fixture()
      assert %Ecto.Changeset{} = Venues.change_venue(venue)
    end
  end
end
