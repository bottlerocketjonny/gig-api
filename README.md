# Gig API

A RESTful API for discovering live music events and venues in Sheffield, built with Phoenix/Elixir.

**[Try it live](https://gig-api-app-production.up.railway.app/swaggerui)** - Interactive API documentation

## Setup

```bash
mix deps.get
mix ecto.setup
mix phx.server
```

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/venues` | List venues |
| GET | `/api/venues/:id` | Get venue |
| POST | `/api/venues` | Create venue |
| PUT | `/api/venues/:id` | Update venue |
| DELETE | `/api/venues/:id` | Delete venue |
| GET | `/api/events` | List events |
| GET | `/api/events/:id` | Get event |
| POST | `/api/events` | Create event |
| PUT | `/api/events/:id` | Update event |
| DELETE | `/api/events/:id` | Delete event |
| POST | `/api/events/:id/buy` | Buy a ticket |
| GET | `/api/events/tonight` | Today's events |
| GET | `/api/search/events` | Search events |

### Pagination

All list endpoints accept `page` and `page_size` query params and return paginated responses with `page_number`, `page_size`, `total_pages`, and `total_entries`.

### Search params

- `city` - Filter by venue city
- `status` - `announced`, `on_sale`, `sold_out`, `cancelled`
- `date_from` - Events on/after date (YYYY-MM-DD)
- `date_to` - Events on/before date (YYYY-MM-DD)

### Ticket purchasing

`POST /api/events/:id/buy` atomically increments `tickets_sold` using `Ecto.Multi`. When capacity is reached, the event status is set to `sold_out` within the same transaction. A PubSub broadcast notifies a `SoldOutChecker` GenServer which handles async side effects (logging, notifications).

## Docs

- Production: https://gig-api-app-production.up.railway.app/swaggerui
- Local: http://localhost:4000/swaggerui
