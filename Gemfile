source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'govuk_elements_rails'
gem 'govuk_frontend_toolkit'
gem 'govuk_template', '0.18.0'
gem 'haml-rails'
gem 'jquery-rails'
gem 'pg'
gem 'rails', '~> 5.0.2'
gem 'sass-rails'
gem 'uglifier'
gem 'unicorn-rails'

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
end

group :development, :test do
  gem 'awesome_print'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :test do
  gem 'codeclimate-test-reporter'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'rspec-mocks'
  gem 'shoulda-matchers', '~> 3.1.0', require: false
  gem 'simplecov'
end
