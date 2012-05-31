module Bork
  class Environment
    attr_accessor :name

    def initialize(name, *options, &block)
      @name = name.to_sym
      @servers = {}

      instance_eval &block
    end

    def server(name, &block)
      require 'bork/server'

      if @servers.include? name
        @servers[name] = @servers[name].update(name, &block)
      else
        @servers[name] = Bork::Server.new(name, &block)
      end
    end
  end
end
