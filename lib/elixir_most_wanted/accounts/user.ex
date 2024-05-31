defmodule ElixirMostWanted.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElixirMostWanted.Accounts.{User}

  schema "users" do
    field :name, :string
    field :token, :string
    field :avatar_url, :string
    field :external_homepage_url, :string
    field :visibility, Ecto.Enum, values: [public: 1, unlisted: 2]

    timestamps()
  end

  def get_visibility(info) do
    # HACK: temporary heuristic to prevent abuse
    with %{"followers" => followers, "created_at" => created_at} <- info,
         {:ok, registered_at, _} <- DateTime.from_iso8601(created_at),
         true <- DateTime.diff(DateTime.utc_now(), registered_at, :second) > 30 * 24 * 60 * 60,
         true <- followers >= 20 do
      :public
    else
      _ -> :unlisted
    end
  end

  @doc """
  A user changeset for github registration.
  """
  def github_registration_changeset(info, token) do

    %{"login" => login, "avatar_url" => avatar_url} = info

    params = %{
      "name" => login,
      "token" => token,
      "avatar_url" => avatar_url,
      "visibility" => get_visibility(info)
    }

    %User{}
    |> cast(params, [:name, :avatar_url, :token, :visibility])
    |> validate_required([:name, :token, :visibility])
  end

  def settings_changeset(%User{} = user, params) do
    user
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
