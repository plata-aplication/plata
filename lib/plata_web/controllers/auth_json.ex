defmodule PlataWeb.AuthJSON do
  def data(%{token: token = %Plata.Auth.AccessToken{}}) do
    %{
      token: token.token
    }
  end

  def validation_error(%{errors: errors}) do
    errors =
      for {field, {_, meta}} <- errors, reduce: %{} do
        acc ->
          meta =
            for {key, value} <- meta, reduce: %{} do
              acc2 -> Map.put(acc2, key, value)
            end

          Map.put(acc, field, meta)
      end

    %{
      errors: errors
    }
  end

  def login_error(%{error: error}) do
    %{
      errors: %{
        unauthorized: error
      }
    }
  end

  def logout_success(_) do
    %{
      success: true
    }
  end

  def user(%{user: user_data = %Plata.Account.User{}}) do
    %{
      user: %{
        name: user_data.name,
        id: user_data.id,
        email: user_data.email,
        tag: "user"
      }
    }
  end

  def anonymous(_) do
    %{
      user: %{
        tag: "anonymous"
      }
    }
  end
end
