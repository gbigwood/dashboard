defmodule CommitsTest do
  use ExUnit.Case
  doctest Commits
  import Commits, only: [commits: 1]

  test "We obtain events" do
    assert 'some commits for gbigwood' = commits('gbigwood')
  end

  # we can find the commits from the site
  # we can find the commits when pushed from locally
end
