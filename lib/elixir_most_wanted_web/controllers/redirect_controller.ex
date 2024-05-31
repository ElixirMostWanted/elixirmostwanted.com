defmodule ElixirMostWantedWeb.RedirectController do
  use ElixirMostWantedWeb, :controller

  import ElixirMostWantedWeb.UserAuth, only: [fetch_current_user: 2]

  plug :fetch_current_user

  def redirect_authenticated(conn, _) do
    if conn.assigns.current_user do
      ElixirMostWantedWeb.UserAuth.redirect_if_user_is_authenticated(conn, [])
    else
      redirect(conn, to: ~p"/auth/login")
    end
  end
end
