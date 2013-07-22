# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'usesguid/version'

Gem::Specification.new do |spec|
  spec.name          = "usesguid"
  spec.version       = Usesguid::VERSION
  spec.authors       = ["C. Jason Harrelson"]
  spec.email         = ["jason@lookforwardenterprises.com"]
  spec.description   = %q{A much faster version of the usesguid plugin for Rails ported to a gem (uses database for GUID generation)}
  spec.summary       = %q{A much faster version of the usesguid plugin for Rails ported to a gem}
  spec.homepage      = "https://github.com/midas/usesguid"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
