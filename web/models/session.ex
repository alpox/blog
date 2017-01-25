defmodule Web.Session do
  alias Web.User
 
  def authenticate(params) do
    user = Web.Repo.get_by(User, username: String.downcase(params.username))
    case check_password(user, params.password) do
      true -> {:ok, user}
      _ -> {:error, "Incorrect login credentials"}
    end
  end
 
  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end
end