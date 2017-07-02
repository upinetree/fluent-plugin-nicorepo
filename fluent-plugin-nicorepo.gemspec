# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent/plugin/nicorepo/version'

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-nicorepo"
  spec.version       = Fluent::Plugin::Nicorepo::VERSION
  spec.authors       = ["upinetree"]
  spec.email         = ["upinetree@gmail.com"]
  spec.summary       = %q{Fluent input plugin for Nicorepo}
  spec.description   = %q{Fluent input plugin for Nicorepo.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
  spec.add_runtime_dependency "nicorepo", "~> 0.0.8"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "test-unit", "~> 3.0"
end
