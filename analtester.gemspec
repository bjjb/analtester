# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'analtester'

Gem::Specification.new do |gem|
  gem.name          = "analtester"
  gem.version       = Analtester::VERSION
  gem.authors       = ["JJ Buckley"]
  gem.email         = ["jj@bjjb.org"]
  gem.description   = %q{Makes some failing tests for you}
  gem.summary       = <<DESCRIPTION
analtester will look through your ./lib directory and create corresponding tests in test/.
They will all fail, until you write them. Use it to quickly populate an untested
library with tests. Just run `analtester` from the command-line in your project's root.
Requires minitest.
DESCRIPTION
  gem.homepage      = "http://github.com/bjjb/analtester"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'minitest' if RUBY_VERSION < "2.0"
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-minitest'
end
