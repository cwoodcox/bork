require 'thor'

module Bork
  class CLI < Thor
    include Thor::Actions
    check_unknown_options!

    source_root File.join(File.dirname(__FILE__), '..', '..', 'templates')

    desc "init", "Create a bork configuration in the current project/directory"
    def init
      empty_directory "config"
      template "config/bork.rb.erb", "config/bork.rb"
    end

    desc "bootstrap", "Read the bork file and fire up some servers."
    def bootstrap
      load_config
      Bork.bootstrap!
    end

    desc "setup", "Start up the servers if they don't exist and set up the softwares"
    def setup
      load_config
      Bork.setup!
    end

    private
    def load_config
      load "#{Dir.pwd}/config/bork.rb"
    end
  end
end
