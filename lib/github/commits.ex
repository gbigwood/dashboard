defmodule Commits do
  require Logger 
  @moduledoc """
  Handles retrieval of github commits from events
  """

  @doc """
  Obtain the commits for a user from a list of events
  """
  def commits(events) do
    Logger.debug "parsing commits"
    events
    |> commits_only
  end

  defp contains_commits(%{"payload"=> %{"commits" => commits}}) do
    Logger.debug "event contains commits"
    true
  end

  defp contains_commits(event) do
    Logger.debug "event has no commits"
    false
  end

  defp commit_info(%{"payload"=> %{"commits" => commits}}) do
    all = fn :get, data, next -> Enum.map(data, next) end
    get_in(commits, [all, "message"])
  end

  defp repo_info(%{"repo"=> %{"name" => name}}) do
    name
  end

  defp commits_only(list_of_events) do
    Enum.filter_map(list_of_events, 
                    fn (e) -> contains_commits(e) end, 
                    fn (event_with_commit) -> 
                      %{:commit_messages => commit_info(event_with_commit), 
                        :repo_name => get_in(event_with_commit, ["repo", "name"])} end)
  end
end
