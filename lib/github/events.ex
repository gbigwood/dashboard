defmodule Events do
  require Logger 
  @moduledoc """
  Handles retrieval of github events
  """

  @user_agent [ {"User-agent", "Elixir greg"} ]
  @github_url Application.get_env(:dashboard, :github_url)

  @doc """
  Obtain the events for a user
  """
  def events(user) do
    Logger.info "Fetching user #{user}'s events"
    commit_url(user)
    |> HTTPoison.get(@user_agent)
    |> handle_response
    |> decode_response
    |> sort_into_ascending_order
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.debug "Successful response"
    Logger.debug fn -> inspect(body) end 
    { :ok, Poison.Parser.parse!(body) }
  end

  defp handle_response({_, %{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
    { :error, Poison.Parser.parse!(body) }
  end

  def sort_into_ascending_order(list_of_events) do
    Enum.sort list_of_events, 
      fn i1,i2 -> Map.get(i1, "created_at") <= Map.get(i2, "created_at") end
  end

  defp commit_url(user) do
    "#{@github_url}/users/#{user}/events"
  end

  defp decode_response({:ok, body}), do: body

  defp decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github #{message}"  # TODO logger?
    System.halt(2)
  end
end
