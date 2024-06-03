defmodule ElixirMostWantedWeb.HomeLiveTest do
  use ElixirMostWantedWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Index" do
    test "lists all wanteds", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Listing Most Wanteds"
    end
  end
end
