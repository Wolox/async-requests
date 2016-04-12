$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "async_request/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "async_request"
  s.version     = AsyncRequest::VERSION
  s.authors     = ["Matias De Santi"]
  s.email       = ["matias.desanti@wolox.com.ar"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AsyncRequest."
  s.description = "TODO: Description of AsyncRequest."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "sidekiq", "~> 4.0"

  s.add_development_dependency "pg"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails", "~> 4.0"
  s.add_development_dependency 'faker'
  s.add_development_dependency 'database_cleaner'
end
