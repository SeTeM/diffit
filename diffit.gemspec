# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'diffit/version'

Gem::Specification.new do |spec|
  spec.name          = "diffit"
  spec.version       = Diffit::VERSION
  spec.authors       = ["Vlad Syabruk"]
  spec.email         = ["sjabrik@gmail.com"]

  spec.summary       = "This thing will track your changes in DB down and write this info in separate table."
  spec.description   = "You easily can get diff of data changed in for exmaple last three minutes."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "rails", "~> 4.2"
  spec.add_development_dependency "database_cleaner", "~> 1.4.1"
  spec.add_development_dependency "activerecord", "~> 4.2.0"
  spec.add_development_dependency "pg"
end
