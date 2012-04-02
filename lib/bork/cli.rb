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
  end
end
