defmodule ElixirMostWantedWeb.Nav do
  use Phoenix.Component


  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
  }
  end
end
