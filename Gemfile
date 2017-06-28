source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'govuk_elements_form_builder', git: 'https://github.com/ministryofjustice/govuk_elements_form_builder.git'
gem 'govuk_elements_rails'
gem 'govuk_frontend_toolkit'
gem 'govuk_template', '0.18.0'
gem 'haml-rails'
gem 'jquery-rails'
gem 'jwt'
gem 'notifications-ruby-client'
gem 'omniauth-oauth2', '>=1.3.1'
gem 'pg'
gem 'rails', '~> 5.0.2'
gem 'rest-client'
gem 'sass-rails'
gem 'uglifier'
gem 'unicorn-rails'
gem 'validates_email_format_of'

group :development do
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
end

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rspec-mocks'
  gem 'shoulda-matchers', '~> 3.1.0', require: false
  gem 'simplecov'
end
