$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "garrison/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "garrison"
  s.version     = Garrison::VERSION
  s.authors     = ["mmmpa"]
  s.email       = ["mmmpa.mmmpa@gmail.com"]
  s.homepage    = "http://mmmpa.net"
  s.summary     = "Authorization"
  s.description = "Authorization"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-html-matchers"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "coveralls"
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'codeclimate-test-reporter'

end
