module Bork
  class Environment
    attr_accessor :servers, :name

    def initialize(name, *options, &block)
      @name = name.to_sym
      @servers = {}

      instance_eval &block
    end

    # DSL Method
    def server(role, &block)
      require 'bork/server'

      @servers[role] = Bork::Server.new(role, :environment => self, &block)
    end

    # TODO: protected?
    def build!
      @servers.each do |role,server|
        server.bootstrap!
      end
    end

    def restore!
      link_provider
      @servers.select { |role,server| server.linked? }.each do |role,server|
        Bork.logger.info(role.to_s) { "Existing instance not found, bootstrapping server." }
        server.bootstrap
      end
    end

    private
    def link_provider
      @servers.each do |role,server|
        Bork.logger.info(role.to_s) { "Searching Rackspace for existing instance" }
        server.instance
      end
    end
  end
end
