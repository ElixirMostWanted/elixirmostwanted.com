defmodule ElixirMostWantedWeb.HomeLive.Index do
  use ElixirMostWantedWeb, :live_view

  alias ElixirMostWanted.Wanteds
  alias ElixirMostWanted.Wanteds.Wanted

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> stream(:wanteds, Wanteds.list_most_wanted())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:wanted, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New")
    |> assign(:wanted, %Wanted{user_id: socket.assigns.current_user.id})
  end
end
