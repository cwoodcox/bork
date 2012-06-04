module Bork
  class Server
    attr_accessor :name, :role, :image_id, :flavor_id, :packages, :environment, :metadata

    def initialize(role, *options, &block)
      options = options.extract_options!

      @role = role.to_sym
      @packages = %w( build-essential zlib1g-dev libpcre3-dev git-core libxml2-dev libxslt-dev libmysqlclient-dev mysql-client openssl libssl-dev)
      @environment = options.delete(:environment)
      @name = "#{@environment.name}.#{@role}.#{Bork.application}.saxtonhorne.net" # TODO: Don't do this.
      @metadata = {
        'application' => Bork.application,
        'role' => role.to_s,
        'environment' => environment.name.to_s
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
      @packages += package_list
    end

    def bootstrap!
      @instance = do_bootstrap # We're providing our own bootstrap because I want some reporting
      @linked = true
    end

    def linked?
      @linked
    end

    def instance
      return @instance if linked?
      @linked = false

      @instance = Bork.provider.servers.find do |server|
        @linked = true if server.metadata == metadata
      end
    end

    def install_packages
      instance.ssh('apt-get -qq update')
      instance.ssh("apt-get -qqy install #{@packages.join(" ")}")
    end

    private
    def do_bootstrap
      log "Creating server"
      server = Bork.provider.servers.create(to_params)

      log "Waiting for server to become ready"
      server.wait_for { ready? }

      log "Setting up keypairs and stuff"
      server.setup(:password => server.password)

      log "Bootstrapped!"
      server
    end

    def log(message)
      Bork.logger.info(role) { message }
    end

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
