# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluentd/plugin/nicorepo/version'

Gem::Specification.new do |spec|
  spec.name          = "fluentd-plugin-nicorepo"
  spec.version       = Fluentd::Plugin::Nicorepo::VERSION
  spec.authors       = ["upinetree"]
  spec.email         = ["essequake@gmail.com"]
  spec.summary       = %q{Fluent input plugin for Nicorepo}
  spec.description   = %q{Fluent input plugin for Nicorepo.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fluentd"
  spec.add_runtime_dependency "nicorepo"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
