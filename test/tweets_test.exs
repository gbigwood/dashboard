defmodule TweetsTest do
  use ExUnit.Case
  doctest Tweets
  import Tweets, only: [tweets: 1]

  test "We obtain tweets" do
    assert length(tweets('gregbigwood'))
  end

  # TODO some spec stuff for the events
end
