# encoding: UTF-8


ProjectConfig = {
  :github_login         => "mvj3",
  :github_password      => ENV["GITHUB_PASSWORD"],

  :organization_names   => ["mvj3", "human-lang", "eoecn", "SunshineLibrary", "17zuoye"],

  :selected_repo_names  => [
      "active_model_as_json_filter",
      "activerecord_idnamecache",
      "acts_as_time_racing",
      "article_segment",
      "compare_word",
      "cross_time_calculation",
      "detdup",
      "deviantart-douban",
      "distribute_tree",
      # "draft",  # actually it's not yet open sourced, it's owned by @mvj3.
      "etl_utils",
      "examples",
      "faye-online",
      "fill_broken_words",
      "hangman",
      "LetPaymentFly",
      "line-tree",  # fork
      "logpos",
      "lui",
      "luigi",  # fork
      "luiti",
      "markdown-ruby-china",  # fork
      "markdownizer",  # fork
      "model_cache",
      "mongoid-mapreduce",  # fork
      "mongoid_many_or_many_to_many_setter",
      "mongoid_sync_with_deserialization",
      "mongoid_touch_parents_recursively",
      "mongoid_unpack_paperclip",
      "mongoid_uuid_generator",
      # "mvj3shell",
      "nested-keys",
      "normalize_nested_params",
      "only_one_rake",

      "oracle_interview_calculation",
      # NOTE oracle_interview_calculation dont appear, even with Octokit.auto_paginate enabled

      "phrase_recognizer",
      "pygments.rb",  # fork
      "pyirt",  # contribute
      "qa-rails",
      "rack_image_assets_cache_control",
      "rails3_acts_as_paranoid",  # fork
      "rake_notifier",   # fork
      "redmine.chosen.js",
      "region_unit_recognizer",
      "rsyncrun",
      "sample-diff",
      "simple_bitbucket",
      "split_block",
      "statlysis",
      "stepstepstep",
      "textmulclassify",
      "tfidf",
      "ucenter_authcode",  # fork
      "validata",
      "videojs_rails",  # fork
      # "xdeploy"
  ],
  :fork_repos => [
    "line-tree",  # fork
    "luigi",  # fork
    "markdownizer",  # fork
    "markdown-ruby-china",  # fork
    "mongoid-mapreduce",  # fork
    "pygments.rb",  # fork
    "pyirt",  # contribute
    "rails3_acts_as_paranoid",  # fork
    "rake_notifier",   # fork
    "ucenter_authcode",  # fork
    "videojs_rails",  # fork
  ]
}
