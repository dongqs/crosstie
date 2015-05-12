require 'yaml'

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
rescue => e
  puts "error on performing #{task}"
  raise e
end

def config
  return @config if @config
  config_path = '/tmp/crosstie/config.yml'
  if File.exist? config_path
    @config = YAML.load(File.read(config_path))
    File.delete config_path
  else
    @config = {}
  end
  @config
end

perform :git_init
perform :change_source
perform :install_gems
perform :bundle_install
perform :add_gitignore
# perform :stop_robots # stop google
perform :skeleton
perform :config_timezone
perform :config_scaffold
perform :serve_static
perform :database_example
perform :figaro
perform :active_job
perform :simple_form
perform :rspec
perform :guard
perform :static_pages
perform :devise
perform :rails_layout # authform for device
perform :user
# perform :ldap # who needs this
perform :controller_helpers
perform :authentication_token
perform :rolify
perform :authorization
perform :helper
perform :resources
perform :seeds
git_commit "project created"
perform :run_test
perform :run_seeds
