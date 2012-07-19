# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bork/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Corey Woodcox"]
  gem.email         = ["corey.woodcox@gmail.com"]
  gem.description   = %q{Bork is my attempt at server bootstrapping.}
  gem.summary       = %q{Maybe one day it will be cooler.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bork"
  gem.require_paths = ["lib"]
  gem.version       = Bork::VERSION

  gem.add_dependency 'thor', '~>0.14'
  gem.add_dependency 'fog', '~>1.3.0'
  gem.add_dependency 'net-ssh', '~>2.3.0'
end
