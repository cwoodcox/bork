require 'bork/version'
require 'bork/core/array'
require 'bork/errors'
require 'fog'

module Bork
  class << self
    attr_reader :environments

    Fog.credentials[:public_key_path] = "~/.ssh/id_rsa.pub"

    def logger
      return @logger if @logger 
      @logger = ::Logger.new(STDOUT)
      @logger.level = ::Logger::INFO
      @logger
    end
    
    def configure(&block)
      @environments = {} 
      instance_eval &block
    end

    def application(*args)
      return @application unless args.length > 0
      options = args.extract_options!
      @application = args.first
    end

    def environment(name, &block)
      require 'bork/environment'

      @environments[name.to_sym] = Bork::Environment.new(name.to_sym, &block)
    end

    def provider(*args)
      return @provider unless args.length > 1
      options = args.extract_options!
      @provider = Fog::Compute.new(options.merge(:provider => args.first)) 
    end

    def bootstrap!
      @environments.each do |name,env|
        env.build!
      end
    end
  end
end
