defmodule GigApi.Repo do
  use Ecto.Repo,
    otp_app: :gig_api,
    adapter: Ecto.Adapters.Postgres
end
