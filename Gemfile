# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', github: 'solidusio/solidus', branch: branch

gemspec

gem 'ffaker'
gem 'mysql2', '~> 0.5'
gem 'pg', '~> 1.1'
gem 'puma'
gem 'sqlite3'
gem 'vcr'
gem 'webmock'

gem 'activemerchant', github: 'activemerchant/active_merchant'
