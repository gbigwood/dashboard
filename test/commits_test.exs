defmodule CommitsTest do
  use ExUnit.Case
  doctest Commits
  import Commits, only: [commits: 1]
  import Events, only: [events: 1]

  test "We obtain commits from events" do
    assert events('gbigwood') |> commits()
  end

  test "We commits sample json events" do
    sample_events = [
    %{"actor" => %{"avatar_url" => "https://avatars.githubusercontent.com/u/478006?",
           "display_login" => "gbigwood", "gravatar_id" => "", "id" => 478006,
           "login" => "gbigwood", "url" => "https://api.github.com/users/gbigwood"},
         "created_at" => "2017-05-12T08:52:36Z", "id" => "5859580711",
         "payload" => %{"description" => "Terminal dashboard",
                "master_branch" => "master", "pusher_type" => "user", "ref" => "master",
                "ref_type" => "branch"}, "public" => true,
         "repo" => %{"id" => 91071253, "name" => "gbigwood/dashboard",
                "url" => "https://api.github.com/repos/gbigwood/dashboard"},
         "type" => "CreateEvent"},
       %{"actor" => %{"avatar_url" => "https://avatars.githubusercontent.com/u/478006?",
              "display_login" => "gbigwood", "gravatar_id" => "", "id" => 478006,
              "login" => "gbigwood", "url" => "https://api.github.com/users/gbigwood"},
            "created_at" => "2017-05-12T09:23:43Z", "id" => "5859772757",
            "payload" => %{"before" => "b4ff40114f9a682215f5dcaa6c4d31999542921c",
                   "commits" => [%{"author" => %{"email" => "gregory.bigwood@springer.com",
                               "name" => "gbigwood"}, "distinct" => true,
                             "message" => "feature(commits): working basic commit",
                             "sha" => "9f6d68b9aef40a2871ad7521467bb929d30a554c",
                             "url" => "https://api.github.com/repos/gbigwood/dashboard/commits/9f6d68b9aef40a2871ad7521467bb929d30a554c"}],
                   "distinct_size" => 1, "head" => "9f6d68b9aef40a2871ad7521467bb929d30a554c",
                   "push_id" => 1735366498, "ref" => "refs/heads/master", "size" => 1},
            "public" => true,
            "repo" => %{"id" => 91071253, "name" => "gbigwood/dashboard",
                   "url" => "https://api.github.com/repos/gbigwood/dashboard"},
            "type" => "PushEvent"}]
    assert [["feature(commits): working basic commit"]] = sample_events |> commits()
  end
  test "Handles multiple commits" do
    sample_events = [
      %{"actor" => %{"avatar_url" => "https://avatars.githubusercontent.com/u/478006?",
             "display_login" => "gbigwood", "gravatar_id" => "", "id" => 478006,
             "login" => "gbigwood", "url" => "https://api.github.com/users/gbigwood"},
           "created_at" => "2017-05-03T08:26:27Z", "id" => "5799786865",
           "payload" => %{"before" => "ce3f54e5ba4815127c0e53a9cdd12a652d3f5b84",
                  "commits" => [%{"author" => %{"email" => "gregory.bigwood@springer.com",
                              "name" => "gbigwood"}, "distinct" => true,
                            "message" => "feature(issues): add github issues",
                            "sha" => "3648b1336ed4943b9cd8e17cf39e194027b8f540",
                            "url" => "https://api.github.com/repos/gbigwood/elixir-issues/commits/3648b1336ed4943b9cd8e17cf39e194027b8f540"},
                                      %{"author" => %{"email" => "gregory.bigwood@springer.com",
                                                  "name" => "gbigwood"}, "distinct" => true,
                                                "message" => "Merge branch 'master' of https://github.com/gbigwood/elixir-issues",
                                                "sha" => "f9169363f0802b8d92f1ee5bc0d6d48a929621eb",
                                                "url" => "https://api.github.com/repos/gbigwood/elixir-issues/commits/f9169363f0802b8d92f1ee5bc0d6d48a929621eb"}],
                  "distinct_size" => 2, "head" => "f9169363f0802b8d92f1ee5bc0d6d48a929621eb",
                  "push_id" => 1716300049, "ref" => "refs/heads/master", "size" => 2},
           "public" => true,
           "repo" => %{"id" => 89710369, "name" => "gbigwood/elixir-issues",
                  "url" => "https://api.github.com/repos/gbigwood/elixir-issues"},
           "type" => "PushEvent"}]
    assert [["feature(issues): add github issues", "Merge branch 'master' of https://github.com/gbigwood/elixir-issues"]] = sample_events |> commits()
  end
end
