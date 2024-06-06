defmodule ElixirMostWantedWeb.WantedLive.Show do
  use ElixirMostWantedWeb, :live_view

  alias ElixirMostWanted.Wanteds

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= @wanted.name %>
    </.header>

    <.list>
      <:item title="Purpose"><%= @wanted.purpose %></:item>
    </.list>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug_id" => slug_id}, _, socket) do
    wanted = Wanteds.get_wanted_by_slug_id!(slug_id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, wanted))
     |> assign(:wanted, wanted)}
  end

  defp page_title(:show, wanted), do: wanted.name
end
