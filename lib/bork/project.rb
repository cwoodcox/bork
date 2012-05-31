module Bork
  class Project
    attr_accessor :name
    
    def initialize(name, *options, &block)
      @name = name 

      instance_eval &block
    end

    def environment(name, &block)
      name = name.to_sym

      if @environments.include? name
        @environments[name] << Bork::Environment.new(name, &block) 
      end
    end
  end
end
