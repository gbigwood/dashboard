defmodule CommitsTest do
  use ExUnit.Case
  doctest Commits
  import Commits, only: [commits: 1]

  test "We obtain commits" do
    assert 'some commits for Greg' = commits('Greg')
  end
end
