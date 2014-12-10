require 'thor'
require 'crosstie'

module Crosstie

  class CLI < Thor

    default_task :help

    desc "new", "create a new rails application"
    def new name
      cmd = "rails new #{name} --template #{template_path}"
      puts cmd
      system cmd
    end

    desc "version", "print the version of current crosstie"
    def version
      puts "crosstie #{Crosstie::VERSION}"
    end
    map %w(-v --version) => :version

    desc "help", "print the help"
    def help
      puts "USAGE:\n\tcrosstie new my_app"
    end
    map %w(-h --help) => :help

    private

    def template_path
      File.join root, "base.rb"
    end

    def root
      File.expand_path File.dirname __FILE__
    end
  end
end
