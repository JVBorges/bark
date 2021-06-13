defmodule Bark.Repo do
  use Ecto.Repo,
    otp_app: :bark,
    adapter: Ecto.Adapters.Postgres
end
