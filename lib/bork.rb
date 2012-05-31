require 'bork/version'
require 'bork/core/array'
require 'fog'

module Bork
  class << self
    attr_reader :environments, :provider

    def configure(&block)
      @environments = []
      instance_eval &block
    end

    def environment(name, &block)
      require 'bork/environment'

      @environments << Bork::Environment.new(name, &block)
    end

    def provider(*args)
      if args.length > 0
        options = args.extract_options!
        @provider = Fog::Compute.new(options.merge(:provider => args.first)) 
      else
        @provider
      end
    end
  end
end
