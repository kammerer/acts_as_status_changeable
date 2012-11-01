# -*- encoding: utf-8 -*-
require File.expand_path('../lib/acts_as_status_changeable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Radosław Bułat", "Tomasz Szymczyszyn"]
  gem.email         = ["tomasz.szymczyszyn@adtaily.com"]
  gem.summary       = %q{Effortless tracking of status changes in models}
  gem.description   = %q{This gem provides the facility to automatically track history of changes in activerecord models built around the concept of state machine.}

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.name          = "acts_as_status_changeable"
  gem.require_paths = ["lib"]
  gem.version       = ActsAsStatusChangeable::VERSION
  gem.required_ruby_version = "~> 1.8.7"

  gem.add_runtime_dependency "activerecord", "~>3"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "ruby-debug"
end
