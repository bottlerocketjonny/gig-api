# Seeds for gig_api
#
# Run with: mix run priv/repo/seeds.exs

alias GigApi.Repo
alias GigApi.Venues.Venue
alias GigApi.Events.Event

Repo.delete_all(Event)
Repo.delete_all(Venue)

leadmill =
  Repo.insert!(%Venue{
    name: "The Leadmill",
    city: "Sheffield",
    capacity: 900,
    venue_type: "club",
    address: "6 Leadmill Rd, Sheffield S1 4SE"
  })

sidney_matilda =
  Repo.insert!(%Venue{
    name: "Sidney and Matilda",
    city: "Sheffield",
    capacity: 250,
    venue_type: "club",
    address: "1 Matilda St, Sheffield S1 4QD"
  })

o2_academy =
  Repo.insert!(%Venue{
    name: "O2 Academy Sheffield",
    city: "Sheffield",
    capacity: 2350,
    venue_type: "arena",
    address: "Arundel Gate, Sheffield S1 2PN"
  })

greystones =
  Repo.insert!(%Venue{
    name: "The Greystones",
    city: "Sheffield",
    capacity: 120,
    venue_type: "pub",
    address: "Greystones Rd, Sheffield S11 7BS"
  })

delicious_clam =
  Repo.insert!(%Venue{
    name: "Delicious Clam",
    city: "Sheffield",
    capacity: 80,
    venue_type: "pub",
    address: "213 Abbeydale Rd, Sheffield S7 1FJ"
  })

hatch =
  Repo.insert!(%Venue{
    name: "Hatch",
    city: "Sheffield",
    capacity: 150,
    venue_type: "club",
    address: "95 Arundel St, Sheffield S1 2NT"
  })

today = Date.utc_today()

Repo.insert!(%Event{
  name: "Slow TV",
  date: today,
  ticket_price: Decimal.new("10.00"),
  tickets_sold: 65,
  status: "on_sale",
  venue_id: delicious_clam.id
})

Repo.insert!(%Event{
  name: "The Tubs",
  date: Date.add(today, 3),
  ticket_price: Decimal.new("14.00"),
  tickets_sold: 120,
  status: "on_sale",
  venue_id: hatch.id
})

Repo.insert!(%Event{
  name: "Snocaps",
  date: Date.add(today, 5),
  ticket_price: Decimal.new("8.00"),
  tickets_sold: 45,
  status: "on_sale",
  venue_id: delicious_clam.id
})

Repo.insert!(%Event{
  name: "Sharp Pins",
  date: Date.add(today, 7),
  ticket_price: Decimal.new("12.00"),
  tickets_sold: 80,
  status: "on_sale",
  venue_id: greystones.id
})

Repo.insert!(%Event{
  name: "This Is Lorelei",
  date: Date.add(today, 10),
  ticket_price: Decimal.new("15.00"),
  tickets_sold: 140,
  status: "on_sale",
  venue_id: hatch.id
})

Repo.insert!(%Event{
  name: "MJ Lenderman",
  date: Date.add(today, 14),
  ticket_price: Decimal.new("18.00"),
  tickets_sold: 220,
  status: "on_sale",
  venue_id: sidney_matilda.id
})

Repo.insert!(%Event{
  name: "The Sea and Cake",
  date: Date.add(today, 18),
  ticket_price: Decimal.new("22.00"),
  tickets_sold: 400,
  status: "on_sale",
  venue_id: leadmill.id
})

Repo.insert!(%Event{
  name: "Hen Ogledd",
  date: Date.add(today, 21),
  ticket_price: Decimal.new("14.00"),
  tickets_sold: 60,
  status: "on_sale",
  venue_id: delicious_clam.id
})

Repo.insert!(%Event{
  name: "Teenage Fanclub",
  date: Date.add(today, 28),
  ticket_price: Decimal.new("28.00"),
  tickets_sold: 750,
  status: "on_sale",
  venue_id: leadmill.id
})

Repo.insert!(%Event{
  name: "The Replacements",
  date: Date.add(today, 35),
  ticket_price: Decimal.new("45.00"),
  tickets_sold: 1800,
  status: "on_sale",
  venue_id: o2_academy.id
})

Repo.insert!(%Event{
  name: "Richard Thompson",
  date: Date.add(today, 42),
  ticket_price: Decimal.new("35.00"),
  tickets_sold: 600,
  status: "on_sale",
  venue_id: leadmill.id
})

Repo.insert!(%Event{
  name: "Greg Freeman",
  date: Date.add(today, 50),
  ticket_price: Decimal.new("10.00"),
  tickets_sold: 0,
  status: "announced",
  venue_id: greystones.id
})

IO.puts(
  "Seeded #{Repo.aggregate(Venue, :count)} venues and #{Repo.aggregate(Event, :count)} events"
)
