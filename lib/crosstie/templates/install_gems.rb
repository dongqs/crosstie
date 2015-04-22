gem 'slim-rails', '3.0.0'
gem 'therubyracer', '0.12.1'
gem 'figaro', '1.0.0'
gem 'bootstrap-sass', '3.3.1.0'
gem 'simple_form', '3.1.0'
gem 'quiet_assets', '1.0.3'
gem 'kaminari', '0.16.1'
gem 'rest-client', '1.7.2'
gem 'puma', '2.10.2'
gem 'mysql2', '0.3.17'

gem 'devise', '3.4.1'
gem 'devise_ldap_authenticatable', '0.8.1'
gem 'rolify', '3.4.1'

gem 'sidekiq', '3.3.0'
gem 'sinatra', '1.4.5'

gem_group :development do
  gem 'better_errors', '2.0.0'
  gem 'binding_of_caller', '0.7.2'
  gem 'rack-mini-profiler', '0.9.2'
  gem 'rails_layout', '1.0.24'
  gem 'annotate', '2.6.5'
end

gem_group :development, :test do
  gem 'spring-commands-rspec', '1.0.4'
  gem 'rspec-rails', '3.1.0'
  gem 'guard-rspec', '4.5.0'
  gem 'factory_girl_rails', '4.5.0'
end

gem_group :test do
  gem 'shoulda', '3.5.0'
  gem 'database_cleaner', '1.3.0'

  gem 'simplecov', '0.9.1', require: false
  gem 'test_after_commit', '0.4.0'
end
