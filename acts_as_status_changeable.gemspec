# -*- encoding: utf-8 -*-
require File.expand_path('../lib/acts_as_status_changeable.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Radosław Bułat", "Tomasz Szymczyszyn"]
  gem.email         = ["tomasz.szymczyszyn@adtaily.com"]
  gem.description   = %q{}
  gem.summary       = %q{}

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.name          = "acts_as_status_changeable"
  gem.require_paths = ["lib"]
  gem.version       = ActsAsStatusChangeable::VERSION
  gem.required_ruby_version = "~> 1.8.7"

  gem.add_runtime_dependency "activerecord", "~>3"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "ruby-debug"
end
