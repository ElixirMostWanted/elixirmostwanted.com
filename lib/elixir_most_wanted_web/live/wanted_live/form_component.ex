defmodule ElixirMostWantedWeb.WantedLive.FormComponent do
  use ElixirMostWantedWeb, :live_component
  alias ElixirMostWanted.Wanteds

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="wanted-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:purpose]} type="textarea" label="Purpose" />

        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{wanted: wanted} = assigns, socket) do
    changeset = Wanteds.change_wanted(wanted)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"wanted" => wanted_params}, socket) do
    changeset =
      socket.assigns.wanted
      |> Wanteds.change_wanted(wanted_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"wanted" => wanted_params}, socket) do
    case Wanteds.insert_wanted(socket.assigns.wanted, wanted_params) do
      {:ok, wanted} ->
        {:noreply,
         socket
         |> put_flash(:info, "Wanted created successfully")
         |> push_navigate(to: ~p"/#{wanted}", replace: true)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
