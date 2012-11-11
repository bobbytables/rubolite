# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubolite/version'

Gem::Specification.new do |gem|
  gem.name          = "rubolite"
  gem.version       = Rubolite::VERSION
  gem.authors       = ["Robert Ross"]
  gem.email         = ["robert@creativequeries.com"]
  gem.description   = %q{Rubolite is a ruby interface to gitolite.}
  gem.summary       = %q{This gem allows you to administer your gitolite instance}
  gem.homepage      = "http://github.com/bobbytables/rubolite"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "awesome_print"
  gem.add_development_dependency "pry"

  gem.add_dependency "grit", "~> 2.5.0"
end
