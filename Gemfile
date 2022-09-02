# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in scrapbook.gemspec.
gemspec

gem 'rails', "~> #{ENV.fetch('RAILS_VERSION', '7.0')}"

# Start debugger with binding.b or debugger [https://github.com/ruby/debug]
gem 'debug', '>= 1.0.0'

gem 'rails-controller-testing'
gem 'rspec'
gem 'rspec-rails'

gem 'rubocop', '~> 1.26', require: false
gem 'rubocop-performance', require: false
gem 'rubocop-rails', require: false
gem 'rubocop-rspec', require: false

gem 'slim'

# For the test application, boxcar, in the test folder
if ENV.fetch('RAILS_VERSION', '7.0').to_i < 7
  gem 'mail', '>= 2.8.0.rc1' # Remove when 2.8.0 released to support ruby 3.1
  gem 'sprockets-rails', require: 'sprockets/railtie'
else
  gem 'propshaft'
end
