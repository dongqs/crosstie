gem 'slim-rails', '3.0.1'
gem 'therubyracer', '0.12.2'
gem 'figaro', '1.1.1'
gem 'bootstrap-sass', '3.3.4.1'
gem 'simple_form', '3.1.0'
gem 'quiet_assets', '1.1.0'
gem 'kaminari', '0.16.3'
gem 'rest-client', '1.8.0'
gem 'puma', '2.11.2'
gem 'mysql2', '0.3.18'

gem 'devise', '3.4.1'
gem 'devise_ldap_authenticatable', '0.8.4'
gem 'rolify', '4.0.0'

gem 'sidekiq', '3.3.4'
gem 'sinatra', '1.4.6'

gem_group :development do
  gem 'better_errors', '2.1.1'
  gem 'binding_of_caller', '0.7.2'
  gem 'rack-mini-profiler', '0.9.3'
  gem 'rails_layout', '1.0.25'
  gem 'annotate', '2.6.8'
  gem 'bullet', '4.14.7'
end

gem_group :development, :test do
  gem 'spring-commands-rspec', '1.0.4'
  gem 'rspec-rails', '3.2.1'
  gem 'guard-rspec', '4.5.0'
  gem 'factory_girl_rails', '4.5.0'
end

gem_group :test do
  gem 'shoulda', '3.5.0'
  gem 'database_cleaner', '1.4.1'

  gem 'simplecov', '0.10.0', require: false
  gem 'test_after_commit', '0.4.1'
end
