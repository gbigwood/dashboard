defmodule Commits do
  require Logger 
  import Events, only: [events: 1]
  @moduledoc """
  Handles retrieval of github commits
  """

  @doc """
  Obtain the commits for a user

  TODO make an example here plz

  """
  def commits(events) do
    Logger.debug "parsing commits"
    events
    |> commits_only
  end

  defp number_of_commits(list_of_events) do
    Enum.map(list_of_events, fn(x) -> commit_count(x) end)
  end

  defp commit_count(%{"payload"=> %{"commits" => commits}}) do
    Logger.debug "event contains commits"
    length(commits)
  end

  defp commit_count(event) do
    Logger.debug "event has no commits"
    0
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

  defp commits_only(list_of_events) do
    Enum.filter_map(list_of_events, 
                    fn (e) -> contains_commits(e) end, 
                    fn (event_with_commit) -> commit_info(event_with_commit) end)
  end
end
