# encoding: UTF-8

require 'octokit'
require_relative "config"
require 'active_support/core_ext/hash/slice'

# TODO translate some Chinese to English
# TODO adjust 2014 2015 with more width


class Mvj3Project

  Steps = [:login_github, :get_data_from_github, :clean_data, :merge_from_default_data, :print_result]
  GithubRepoKeys = [:name, :description, :html_url, :created_at, :updated_at, :pushed_at, :language]

  attr :selected_repos_data_in_view, :all_repos

  def run
    puts "### open sources projects"
    puts "self: #{ProjectConfig[:selected_repo_names].size - ProjectConfig[:fork_repos].size}"
    puts "fork: #{ProjectConfig[:fork_repos].size}"
    puts

    Steps.each_with_index do |step, idx|
      puts "\n[step##{idx + 1}] #{step.to_s.gsub('_', ' ')}"
      self.send(step)
    end
  end

  def login_github
    Octokit.configure do |c|
      c.login    = ProjectConfig[:github_login]
      c.password = ProjectConfig[:github_password]
    end

    # https://github.com/octokit/octokit.rb#auto-pagination
    Octokit.auto_paginate = true

    puts "[info] login github ..."
    all_organization_names = ProjectConfig[:organization_names]
    @all_organizations = all_organization_names.map {|name| Octokit.user name }
  end

  def get_data_from_github
    puts "[info] read data from github, begin ..."
    @all_repos = @all_organizations.map do |organization|
      repos = organization.rels[:repos].get.data
      repos
    end.flatten
    puts "[read] ... end"
  end

  def clean_data
    # select keys
    @all_repos_summary = @all_repos.map do |repo_orig|
      repo_orig.attrs.slice(*GithubRepoKeys)
    end.uniq

    # filter by :selected_repo_names
    @all_repos_summary = @all_repos_summary.select {|i| ProjectConfig[:selected_repo_names].include? i[:name] }

    # remove duplicated data
    prefer_regexp = /\/mvj3\/|\/luiti\//i  # compact with uppercase
    prefered_repos = @all_repos_summary.select {|i| prefer_regexp.match(i[:html_url]) }.map {|i| i[:name] }.uniq
    selected_repos_summary = @all_repos_summary.select {|i| prefered_repos.include?(i[:name]) ? prefer_regexp.match(i[:html_url]) : true }

    # merge max date range from orig fork
    @selected_repos_summary_dict = selected_repos_summary.inject(Hash.new) {|hash, item| hash[item[:name]] = item; hash }
    @all_repos_summary.each do |orig_item|
      if orig_item[:created_at] < @selected_repos_summary_dict[orig_item[:name]][:created_at]
          @selected_repos_summary_dict[orig_item[:name]][:created_at] = orig_item[:created_at]
      end

      if orig_item[:pushed_at] > @selected_repos_summary_dict[orig_item[:name]][:pushed_at]
          @selected_repos_summary_dict[orig_item[:name]][:pushed_at] = orig_item[:pushed_at]
      end
    end

    # fix data
    @selected_repos_summary_dict["deviantart-douban"][:created_at] = Time.parse("Dec 10, 2009")

    @selected_repos_summary_dict["statlysis"][:html_url] = "https://github.com/mvj3/statlysis"


    @selected_repos_data_in_view = @selected_repos_summary_dict.values.sort_by {|x| x[:created_at] }.reverse
    @selected_repos_data_in_view = @selected_repos_data_in_view.map {|i| timesheet_format(i) }

    # used for programming language color, just as Github.com used.
    @repo_to_language_dict = @all_repos_summary.inject(Hash.new) {|h, i| h[i[:name]] = i[:language]; h }
    # fix data
    ["active_model_as_json_filter", "mongoid_many_or_many_to_many_setter", "mongoid_sync_with_deserialization", "mongoid_unpack_paperclip", "mongoid_uuid_generator"].each do |repo|
      @repo_to_language_dict[repo] = "Ruby"
    end

    ["draft"].each do |repo|
      @repo_to_language_dict[repo] = "HTML"
    end
  end

  def merge_from_default_data
  end

  def print_result
    # 5. jsonify data
    puts "window.orig_data = #{@selected_repos_data_in_view.inspect};"
    puts "window.repo_to_language_dict = #{@repo_to_language_dict.to_json};"
    puts "window.fork_repos = #{ProjectConfig[:fork_repos].inspect};"

    require 'byebug'
    byebug
  end

  private
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

end

mp = Mvj3Project.new
mp.run
