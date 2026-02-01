# Gig API

Phoenix API for live music events.

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
| GET | `/api/events/tonight` | Today's events |
| GET | `/api/search/events` | Search events |

### Search params

- `city` - Filter by venue city
- `status` - `announced`, `on_sale`, `sold_out`, `cancelled`
- `date_from` - Events on/after date (YYYY-MM-DD)
- `date_to` - Events on/before date (YYYY-MM-DD)

## Docs

Swagger UI: http://localhost:4000/swaggerui
