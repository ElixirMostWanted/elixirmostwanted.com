defmodule ElixirMostWantedWeb.HomeLive.Index do
  use ElixirMostWantedWeb, :live_view

  alias ElixirMostWanted.Wanteds

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> stream(:wanteds, Wanteds.list_most_wanted())
    }
  end
end
