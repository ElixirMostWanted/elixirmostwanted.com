defmodule ElixirMostWantedWeb.HomeLive.Index do
  use ElixirMostWantedWeb, :live_view

  alias ElixirMostWanted.Wanteds

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> stream_configure(:wanteds, dom_id: &"wanteds-#{&1.wanted.id}")
      |> stream(:wanteds, Wanteds.list_most_wanted())
    }
  end
end
