module Bork
  class Server
    attr_accessor :name, :role, :image_id, :flavor_id, :packages, :environment

    def initialize(role, *options, &block)
      options = options.extract_options!

      @role = role.to_sym
      @packages = []
      @environment = options.delete(:environment)
      @name = "#{@environment.name}.#{@role}.#{Bork.application}.saxtonhorne.net" # TODO: Don't do this.

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

    def create!
      Bork.logger.info(name) { "Creating..." }
      @instance = Bork.provider.servers.create(self.to_params)
      Bork.logger.info(name) { "Done." }
    end

    def ready?
      @instance.ready?
    end

    def bootstrap!
      Bork.logger.info(name) { "Waiting for ready..." }
      Bork.provider.wait_for { ready? } 

    end

    protected
    def to_params
      {
        :name => name,
        :image_id => image_id,
        :flavor_id => flavor_id,
        :metadata => {
          'application' => Bork.application,
          'role' => role,
          'environment' => environment.name
        }
      }
    end
  end
end
