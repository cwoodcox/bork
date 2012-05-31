module Bork
  class Environment
    @config = Config.new

    def server(&block)
      @config.instance_eval(block)
    end
  end
end
