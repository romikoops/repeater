# -*- encoding: utf-8 -*-
require File.expand_path('../lib/repeater/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Roman Parashchenko"]
  gem.email         = %w(romikoops1@gmail.com)
  gem.description   = %q{Flexible Ruby code re-execution}
  gem.summary       = %q{The gem allows to handle specific exceptions for some code, and try to execute code again }
  gem.homepage      = "https://github.com/romikoops/repeater"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "repeater"
  gem.require_paths = ["lib"]
  gem.version       = Repeater::VERSION
end
