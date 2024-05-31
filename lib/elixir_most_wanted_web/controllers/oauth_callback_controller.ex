defmodule ElixirMostWantedWeb.OAuthCallbackController do
  use ElixirMostWantedWeb, :controller
  require Logger

  alias ElixirMostWanted.Accounts

  def new(conn, %{"provider" => "github", "code" => code, "state" => state} = params) do
    client = github_client(conn)

    with {:ok, info} <- client.exchange_access_token(code: code, state: state),
         %{info: info, token: token} = info,
         {:ok, user} <- Accounts.register_github_user(info, token) do
      conn =
        if params["return_to"] do
          conn |> put_session(:user_return_to, params["return_to"])
        else
          conn
        end

      conn
      |> put_flash(:info, "Welcome, #{user.name}!")
      |> ElixirMostWantedWeb.UserAuth.log_in_user(user)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.debug("failed GitHub insert #{inspect(changeset.errors)}")

        conn
        |> put_flash(
          :error,
          "We were unable to fetch the necessary information from your GitHub account"
        )
        |> redirect(to: "/")

      {:error, reason} ->
        Logger.debug("failed GitHub exchange #{inspect(reason)}")

        conn
        |> put_flash(:error, "We were unable to contact GitHub. Please try again later")
        |> redirect(to: "/")
    end
  end

  def new(conn, %{"provider" => "github", "error" => "access_denied"}) do
    redirect(conn, to: "/")
  end

  def sign_out(conn, _) do
    ElixirMostWantedWeb.UserAuth.log_out_user(conn)
  end

  defp github_client(conn) do
    conn.assigns[:github_client] || ElixirMostWanted.Github
  end
end
