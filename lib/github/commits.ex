defmodule Commits do
  require Logger 
  @moduledoc """
  Handles retrieval of github commits
  """

  @user_agent [ {"User-agent", "Elixir greg"} ]
  @github_url Application.get_env(:dashboard, :github_url)

  @doc """
  Obtain the commits for a user

  TODO make an example here plz

  """
  def commits(user) do
    Logger.info "Fetching user #{user}'s commits"
    commit_url(user)
    |> HTTPoison.get(@user_agent)
    |> handle_response
    |> decode_response
    |> sort_into_ascending_order
    |> number_of_commits
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end 
    { :ok, Poison.Parser.parse!(body) }
  end

  defp handle_response({_, %{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
    { :error, Poison.Parser.parse!(body) }
  end

  def sort_into_ascending_order(list_of_issues) do
    Enum.sort list_of_issues, 
      fn i1,i2 -> Map.get(i1, "created_at") <= Map.get(i2, "created_at") end
  end

  defp commit_url(user) do
    "#{@github_url}/users/#{user}/events"
  end

  defp number_of_commits(list_of_events) do
    Enum.map(list_of_events, fn(x) -> find_commits(x) end)
  end

  defp find_commits(%{"payload"=> %{"commits" => commits}}) do
    Logger.info "event contains commits"
    length(commits)
  end

  defp find_commits(event) do
    Logger.info "event has no commits"
    0
  end

  defp decode_response({:ok, body}), do: body

  defp decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github #{message}"
    System.halt(2)
  end
end
