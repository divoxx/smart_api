$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "smart_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "smart_api"
  s.version     = SmartApi::VERSION
  s.authors     = ["Rodrigo Kochenburger"]
  s.email       = ["divoxx at gmail dot com"]
  s.homepage    = "http://github.com/divoxx/smart_api"
  s.summary     = "Summary of SmartApi."
  s.description = "Description of SmartApi."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  # s.add_dependency "rails", "~> 4.0"
  s.add_development_dependency "rspec", "~> 2.12"
  s.add_development_dependency "rspec-rails", "~> 2.12"
end
