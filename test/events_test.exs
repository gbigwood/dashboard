defmodule EventsTest do
  use ExUnit.Case
  doctest Events
  import Events, only: [events: 1]

  test "We obtain events" do
    assert length(events('gbigwood'))
  end

  # TODO some spec stuff for the events
end
