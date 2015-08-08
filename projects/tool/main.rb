# encoding: UTF-8

require 'octokit'
require_relative "config"
require 'active_support/core_ext/hash/slice'

GithubRepoKeys = [:name, :description, :html_url, :created_at, :updated_at, :pushed_at, :language]


# 1. login github
Octokit.configure do |c|
  c.login    = ProjectConfig[:github_login]
  c.password = ProjectConfig[:github_password]
end

puts "[info] login github ..."
all_organization_names = ProjectConfig[:organization_names]
all_organizations = all_organization_names.map {|name| Octokit.user name }


# 2. get data from github
puts "[info] read from remote begin ..."
all_repos = all_organizations.map do |organization|
  repos = organization.rels[:repos].get.data
  repos
end.flatten
puts "[read] ... end."


# 3. clean data
# select keys
all_repos_summary = all_repos.map do |repo_orig|
  repo_orig.attrs.slice(*GithubRepoKeys)
end.uniq.sort_by {|x| x[:name].downcase }

# filter by :selected_repo_names
all_repos_summary = all_repos_summary.select {|i| ProjectConfig[:selected_repo_names].include? i[:name] }

# remote duplicated data
prefer_mvj3_repos = all_repos_summary.select {|i| i[:html_url].include? "/mvj3/" }.map {|i| i[:name] }.uniq
all_repos_summary = all_repos_summary.select {|i| prefer_mvj3_repos.include?(i[:name]) ? i[:html_url].include?("/mvj3/") : true }

# 4. transform data
def timesheet_format(item)
  # example timesheet required data format ['2002', '09/2002', 'A freaking awesome time', 'lorem'],
  return [
    item[:created_at].to_date.to_s,
    item[:pushed_at].to_date.to_s,
    item[:description],
    item[:name],
  ]
end
all_repo_data_in_view = all_repos_summary.map {|i| timesheet_format(i) }



require 'byebug'
byebug

all_repos.size
all_repo_data_in_view.size
