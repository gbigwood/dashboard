defmodule Tweets do
  require Logger 
  @moduledoc """
  Handles retrieval of github events
  """

  @user_agent [ {"User-agent", "Elixir greg"} ]
  @twitter_url Application.get_env(:dashboard, :twitter_url)

  @doc """
  Obtain the tweets for a user
  """
  def tweets(user) do
    Logger.info "Fetching user #{user}'s tweets"
    tweet_url(user)
  end

  defp tweet_url(user) do
    # TODO clearly wrong
    "#{@twitter_url}/#{user}"
  end

end
