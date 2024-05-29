defmodule ElixirMostWanted.Repo do
  use Ecto.Repo,
    otp_app: :elixir_most_wanted,
    adapter: Ecto.Adapters.Postgres
end
