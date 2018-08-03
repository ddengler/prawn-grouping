# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prawn/grouping/version'

Gem::Specification.new do |spec|
  spec.name                      = "prawn-grouping"
  spec.version                   = Prawn::Grouping::VERSION
  spec.authors                   = ["Daniel Dengler"]
  spec.email                     = ["me@ddengler.com"]
  spec.summary                   = "Grouping extension for prawn pdf generator"
  spec.homepage                  = ""
  spec.license                   = "MIT"
  spec.platform                  = Gem::Platform::RUBY

  spec.files                     = `git ls-files -z`.split("\x0")
  spec.test_files                = Dir[ "spec/*_spec.rb" ]
  spec.require_path              = "lib"
  spec.required_ruby_version     = '>= 2.3.0'
  spec.required_rubygems_version = ">= 2.0.0"

  spec.add_dependency "prawn", ">= 2.0.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pdf-inspector", "~> 1.3.0"
  spec.add_development_dependency "pdf-reader", "~>2.1.0"
  spec.add_development_dependency "growl"
end
