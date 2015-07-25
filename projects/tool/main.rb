# encoding: UTF-8

require 'octokit'
require_relative "config"


Octokit.configure do |c|
  c.login    = ProjectConfig[:github_login]
  c.password = ProjectConfig[:github_password]
end

all_organization_names = ProjectConfig[:organization_names]
all_organizations = all_organization_names.map {|name| Octokit.user name }

all_repos = all_organizations.map do |organization|
  repos = organization.rels[:repos].get.data
  repos
end.flatten


require 'active_support/core_ext/hash/slice'
RepoKeys = [:name, :description, :html_url, :created_at, :updated_at, :pushed_at, :language]

all_repos_summary = all_repos.map do |repo_orig|
  repo_orig.attrs.slice(*RepoKeys)
end.uniq.sort_by {|x| x[:name].downcase }

all_repos_summary.map {|i| i[:name] }.uniq.inspect

require 'byebug'
byebug

all_repos.size
