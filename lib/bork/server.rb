module Bork
  class Server
    attr_accessor :name, :role, :image_id, :flavor_id, :packages, :environment, :metadata

    def initialize(role, *options, &block)
      options = options.extract_options!

      @role = role.to_sym
      @packages = []
      @environment = options.delete(:environment)
      @name = "#{@environment.name}.#{@role}.#{Bork.application}.saxtonhorne.net" # TODO: Don't do this.
      @metadata = {
        'application' => Bork.application,
        'role' => role,
        'environment' => environment.name
      }

      if block.arity == 1
        block[self]
      else
        instance_eval &block
      end
    end

    def image(id)
      @image_id = id.to_i
    end

    def flavor(id)
      @flavor_id = id.to_i
    end

    def packages(package_list)
      @packages << package_list
    end

    def bootstrap!
      @instance = Bork.provider.servers.bootstrap(to_params)
    end

    def linked?
      @linked
    end

    def instance
      return @instance if linked?
      @instance = environment.servers.find do |server|
        @linked = true if server.metadata == metadata
      end
    end

    private
    def to_params
      {
        :name => name,
        :image_id => image_id,
        :flavor_id => flavor_id,
        :metadata => metadata
      }
    end
  end
end
