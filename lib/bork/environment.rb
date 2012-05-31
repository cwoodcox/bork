module Bork
  class Environment
    attr_accessor :name

    def initialize(name, *options, &block)
      @name = name.to_sym
    end

    def server(name, &block)
      if @servers.include? name
        @environments[name] = Bork::Server.new(new, &block)
      end
    end
  end
end
