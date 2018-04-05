source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'daemons'
gem 'delayed_job_active_record'
gem 'govuk_elements_form_builder'
gem 'govuk_elements_rails'
gem 'govuk_frontend_toolkit'
gem 'govuk_template', '0.18.0'
gem 'haml-rails'
gem 'jquery-rails'
gem 'jwt'
gem 'nomis-api-client'
gem 'notifications-ruby-client', '2.1.0' # TODO: handle unset API key
gem 'omniauth-oauth2', '>=1.3.1'
gem 'pg'
gem 'rack-throttle'
gem 'rails', '~> 5.1.6'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'rest-client'
gem 'sass-rails'
gem 'uglifier'
gem 'unicorn-rails'
gem 'validates_email_format_of'
gem 'tzinfo-data'

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
  gem 'cucumber', '~> 2.4.0', require: false
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'launchy'
  gem 'mechanize'
  gem 'rails-controller-testing'
  gem 'rspec-mocks'
  gem 'shoulda-matchers', '~> 3.1.0', require: false
  gem 'simplecov'
end
