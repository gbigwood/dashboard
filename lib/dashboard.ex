defmodule Dashboard do
  @moduledoc """
  Documentation for Dashboard.
  """
  import Commits, only: [commits: 1]
  import Events, only: [events: 1]


  @doc """
  Dashboard
  """
  def main(argv) do
    argv
    |> parse_args
    |> process
    |> events
    |> commits
    |> Enum.each(&(printout(&1)))
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h: :help  ])
    case parse do
      { [ help: true ], _, _ } -> :help

      { _, [ user ], _ }
        -> user

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: dashboard <user>
    """
    System.halt(0)
  end

  def process(user) do 
    # TODO get rid of this function
    user
  end

  defp printout(%{:commit_messages=>messages, :repo_name=>name}) do
    Enum.each(messages, fn (msg) -> IO.puts "#{name}\t#{msg}" end)
  end
end
