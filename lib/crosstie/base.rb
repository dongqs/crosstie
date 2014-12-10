def git_commit message
  git add: '-A'
  git commit: "-a -m '#{message}'"
end

def root
  @root ||= File.expand_path File.dirname __FILE__
end

def read_template *path
  File.read File.join root, "templates", *path
end

def perform task
  eval File.read File.join root, "templates", "#{task}.rb"
end

perform :git_init
perform :change_source
perform :install_gems
perform :bundle_install
perform :add_gitignore
# perform :stop_robots # stop google
perform :config_timezone
perform :config_scaffold
perform :serve_static
perform :database_example
perform :figaro
perform :sidekiq
perform :simple_form
perform :rails_layout
perform :rspec
perform :guard
perform :static_pages
perform :devise
perform :skeleton
perform :user
# perform :ldap # who needs this
perform :controller_helpers
perform :authentication_token
perform :rolify
perform :authorization
perform :seeds
perform :resources
git_commit "project created"
perform :run_test
