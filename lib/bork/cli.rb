require 'thor'

module Bork
  class CLI < Thor
    include Thor::Actions
    check_unknown_options!

    desc "init", "Create a bork configuration in the current project/directory"
    def init
      run "mkdir -p config"
      run "touch config/bork.rb"
    end
  end
end
