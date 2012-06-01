module Bork
  class Environment
    attr_accessor :name

    def initialize(name, *options, &block)
      @name = name.to_sym
      @servers = {}

      instance_eval &block
    end

    def server(role, &block)
      require 'bork/server'

      @servers[role] = Bork::Server.new(role, :environment => self, &block)
    end

    def build!
      @servers.each do |role,server|
        server.create!
      end
    end
  end
end
