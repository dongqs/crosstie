require 'thor'
require 'crosstie'

module Crosstie

  class CLI < Thor

    desc "new my_app", "create a new rails application"
    def new name
      cmd = "rails new #{name} --template #{template_path}"
      puts cmd
      system cmd
    end

    desc "version", "print current version"
    def version
      puts "crosstie #{Crosstie::VERSION}"
    end
    map %w(-v --version) => :version

    private

    def template_path
      File.join root, "base.rb"
    end

    def root
      File.expand_path File.dirname __FILE__
    end
  end
end
