# application.rb
# change timezone to beijing
gsub_file "config/application.rb", "# config.time_zone = 'Central Time (US & Canada)'", "config.time_zone = 'Beijing'"
