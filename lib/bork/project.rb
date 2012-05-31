module Bork
  class Project
    attr_accessor :name
    
    def initialize(name, *options, &block)
      @name = name.to_sym 
      @environments = {}

      instance_eval &block
    end

    def environment(name, &block)
      if @environments.include? name
        @environments[name] = @environments[name].update(name, &block) 
      else
        @environments[name] = Bork::Environment.new(name, &block)
      end
    end
  end
end
