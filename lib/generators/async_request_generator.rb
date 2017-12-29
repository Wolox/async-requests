require 'rails/generators/base'

class AsyncRequestGenerator < Rails::Generators::Base
  source_root File.expand_path('../../templates', __FILE__)

  def copy_initializer_file
    migration_file = 'create_async_request_jobs.rb'
    now = Time.zone.now.strftime('%Y%m%d%H%M%S') # rubocop:disable Style/FormatStringToken
    copy_file migration_file, "db/migrate/#{now}_#{migration_file}"

    config_file = 'async_request.rb'
    copy_file config_file, "config/initializers/#{config_file}"
  end
end
