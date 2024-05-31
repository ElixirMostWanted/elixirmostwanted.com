defmodule ElixirMostWanted.Accounts do
  import Ecto.Query
  import Ecto.Changeset

  alias ElixirMostWanted.{Repo}
  alias ElixirMostWanted.Accounts.{User}

  def list_users(opts) do
    Repo.all(from u in User, limit: ^Keyword.fetch!(opts, :limit))
  end

  def get_users_map(user_ids) when is_list(user_ids) do
    Repo.all(from u in User, where: u.id in ^user_ids, select: {u.id, u})
  end

  def admin?(%User{} = user) do
    user.name in ElixirMostWanted.config([:admin_names])
  end

  def update_settings(%User{} = user, attrs) do
    user |> change_settings(attrs) |> Repo.update()
  end
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user_by!(fields), do: Repo.get_by!(User, fields)

  def register_github_user(info, token) do
    if user = get_user_by_provider_name(:github, info["login"]) do
      update_github_token(user, token)
    else
      info
      |> User.github_registration_changeset(token)
      |> Repo.insert()
    end
  end

  def get_user_by_provider_name(provider, name) when provider in [:github] do
    query =
      from(u in User,
        where:
          fragment("lower(?)", u.name) == ^String.downcase(name)
      )

    Repo.one(query)
  end

  def change_settings(%User{} = user, attrs) do
    User.settings_changeset(user, attrs)
  end

  defp update_github_token(%User{} = user, new_token) do
    user_ref =
      get_user_by_provider_name(:github, user.name)

    {:ok, _} =
      user_ref
      |> change()
      |> put_change(:token, new_token)
      |> Repo.update()

    {:ok, user_ref}
  end
end
