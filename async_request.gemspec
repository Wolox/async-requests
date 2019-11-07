$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'async_request/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'async_request'
  s.version     = AsyncRequest::VERSION
  s.authors     = ['Matias De Santi', 'Alejandro Bezdjian', 'Alan Halatian']
  s.email       = ['matias.desanti@wolox.com.ar', 'alejandro.bezdjian@wolox.com.ar', 'alan.halatian@wolox.com.ar']
  s.homepage    = 'https://github.com/Wolox/async-requests'
  s.summary     = 'Perform background jobs and ask for the result in a simple way.'
  s.description = 'Perform background jobs and ask for the result in a simple way.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'jwt', '~> 2.1'
  s.add_dependency 'rails', '>= 4.2'
  s.add_dependency 'sidekiq', '>= 4.0', '< 6'
  s.add_dependency 'sidekiq-cron', "~> 1.1"

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop', '~> 0.52'
  s.add_development_dependency 'sidekiq-cron'
end
