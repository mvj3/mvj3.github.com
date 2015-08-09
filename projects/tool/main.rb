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
puts "[info] read data from github, begin ..."
all_repos = all_organizations.map do |organization|
  repos = organization.rels[:repos].get.data
  repos
end.flatten
puts "[read] ... end"


# 3. clean data
# select keys
all_repos_summary = all_repos.map do |repo_orig|
  repo_orig.attrs.slice(*GithubRepoKeys)
end.uniq.sort_by {|x| x[:created_at] }.reverse

# filter by :selected_repo_names
all_repos_summary = all_repos_summary.select {|i| ProjectConfig[:selected_repo_names].include? i[:name] }

# remove duplicated data
prefer_mvj3_repos = all_repos_summary.select {|i| i[:html_url].include? "/mvj3/" }.map {|i| i[:name] }.uniq
selected_repos_summary = all_repos_summary.select {|i| prefer_mvj3_repos.include?(i[:name]) ? i[:html_url].include?("/mvj3/") : true }

# merge max date range from orig fork
selected_repos_summary_dict = selected_repos_summary.inject(Hash.new) {|hash, item| hash[item[:name]] = item; hash }
all_repos_summary.each do |orig_item|
  if orig_item[:created_at] < selected_repos_summary_dict[orig_item[:name]][:created_at]
      selected_repos_summary_dict[orig_item[:name]][:created_at] = orig_item[:created_at]
  end

  if orig_item[:pushed_at] > selected_repos_summary_dict[orig_item[:name]][:pushed_at]
      selected_repos_summary_dict[orig_item[:name]][:pushed_at] = orig_item[:pushed_at]
  end
end


# TODO translate some Chinese to English
# 1. statlysis
# 2. logpos date range

# 4. transform data
def timesheet_format(item)
  # example timesheet required data format ['2002', '09/2002', 'A freaking awesome time', 'lorem'],
  return [
    item[:created_at].strftime("%m/%Y"),
    item[:pushed_at].strftime("%m/%Y"),
    item[:name],
    'ipsum',
    item[:description],
    item[:html_url],
  ]
end
selected_repos_data_in_view = selected_repos_summary.map {|i| timesheet_format(i) }
puts selected_repos_data_in_view.inspect



require 'byebug'
byebug

all_repos.size
all_repo_data_in_view.size
