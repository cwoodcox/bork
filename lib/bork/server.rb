module Bork
  class Server
    attr_accessor :name, :role, :image_id, :flavor_id, :packages

    def initialize(role, *options, &block)
      @role = role.to_sym
      @packages = []
      # handle the options dude

      if block.arity == 1
        block[self]
      else
        instance_eval &block
      end
    end

    def image_id(id)
      @image_id = id.to_i
    end

    def flavor_id(id)
      @flavor_id = id.to_i
    end

    def packages(package_list)
      @packages << package_list
    end
  end
end
