$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "async_request/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "async_request"
  s.version     = AsyncRequest::VERSION
  s.authors     = ["Matias De Santi"]
  s.email       = ["mdesanti90@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AsyncRequest."
  s.description = "TODO: Description of AsyncRequest."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "sidekiq", "~> 4.0"

  s.add_development_dependency "pg"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec-rails", "~> 2.12.2"
  s.add_development_dependency "factory_girl_rails", "~> 4.0"
end
