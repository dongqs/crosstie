require 'thor'
require 'fileutils'
require 'crosstie'

module Crosstie

  class CLI < Thor

    desc 'new my_app', 'create a new rails application'
    def new name
      if File.exist? 'config.yml'
        FileUtils.mkdir_p '/tmp/crosstie'
        FileUtils.cp 'config.yml', '/tmp/crosstie/config.yml'
      end
      cmd = "rails new #{name} --template #{template_path}"
      puts cmd
      system cmd
    end

    desc 'config', 'create a config.yml template'
    option :local, type: :boolean
    def config
      puts 'writing config.yml'
      File.write 'config.yml', <<-EOF
options:
  local: #{!!options[:local]}
resources:
  article:
    - title:string
    - content:text
  comment:
    - article:references
    - content:text
      EOF
    end

    desc 'version', 'print current version'
    def version
      puts "crosstie #{Crosstie::VERSION}"
    end
    map %w(-v --version) => :version

    private

    def template_path
      File.join root, 'base.rb'
    end

    def root
      File.expand_path File.dirname __FILE__
    end
  end
end
