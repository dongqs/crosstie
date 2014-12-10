gem 'slim-rails'
gem 'therubyracer'
gem 'figaro'
gem 'bootstrap-sass'
gem 'simple_form'
gem 'quiet_assets'
gem 'kaminari'
gem 'rest-client'
gem 'puma'
gem 'mysql2'

gem 'devise'
gem 'devise_ldap_authenticatable'
gem 'rolify'

gem 'sidekiq'
gem 'sinatra'

gem_group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rack-mini-profiler'
  gem 'rails_layout'
  gem 'annotate'
end

gem_group :development, :test do
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
end

gem_group :test do
  gem 'shoulda'
  gem 'database_cleaner'

  gem 'simplecov', require: false
  gem 'test_after_commit'
end
