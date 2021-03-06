# active_job
append_file "config/application.yml", <<-EOF
REDIS_HOST: localhost
REDIS_PORT: "6379"
EOF
run "cp config/application.yml config/application.yml.example"

create_file "config/initializers/sidekiq.rb", <<-EOF
#Sidekiq.configure_server do |config|
#  config.redis = { :url => "redis://\#{ENV['REDIS_HOST']}:\#{ENV['REDIS_PORT']}/0", :namespace => '#{app_path}' }
#end
#
#Sidekiq.configure_client do |config|
#  config.redis = { :url => "redis://\#{ENV['REDIS_HOST']}:\#{ENV['REDIS_PORT']}/0", :namespace => '#{app_path}' }
#end
EOF

create_file "tmp/pids/.keep", ""
create_file "config/sidekiq.yml", <<-EOF
---
:verbose: true
:pidfile: ./tmp/pids/sidekiq.pid
:logfile: ./log/sidekiq.log
:queues:
  - default
development:
  :concurrency: 1
production:
  :concurrency: 2
EOF

inject_into_file "config/routes.rb", after: "# active_job\n" do
<<-EOF
  require 'sidekiq/web'
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
EOF
end

inject_into_file "config/application.rb", after: "# active_job\n" do
<<-EOF
    config.active_job.queue_name_prefix = Rails.env
    config.active_job.queue_name_delimiter = '.'
    # config.active_job.queue_adapter = :sidekiq
EOF
end
