# -*- encoding: utf-8 -*-
require File.expand_path('../lib/simple-conf/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexander Korsak"]
  gem.email         = ["alex.korsak@gmail.com"]
  gem.description   = "Simple configuration library for yml files for loading from the config folder"
  gem.summary       = "Simple configuration library for yml files for loading from the config folder"
  gem.homepage      = "http://github.com/oivoodoo/simple-conf/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "simple-conf"
  gem.require_paths = ["lib"]
  gem.version       = SimpleConf::VERSION

  gem.license = 'MIT'

  gem.add_dependency('rake')
end

