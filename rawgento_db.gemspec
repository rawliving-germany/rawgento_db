# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rawgento_db/version'

Gem::Specification.new do |spec|
  spec.name          = "rawgento_db"
  spec.version       = RawgentoDB::VERSION
  spec.authors       = ["Felix Wolfsteller"]
  spec.email         = ["felix.wolfsteller@gmail.com"]

  spec.summary       = %q{Braindead magento mysql interface}

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rawgento_models"
  spec.add_dependency "mysql2"
  spec.add_dependency "terminal-table"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
