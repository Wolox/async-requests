require 'sidekiq'
module AsyncRequest
  class Engine < ::Rails::Engine
    isolate_namespace AsyncRequest

    initializer 'async_request', before: :load_config_initializers do |app|
      Rails.application.routes.append do
        mount AsyncRequest::Engine, at: '/async_request'
      end

      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          Rails.application.config.paths['db/migrate'] << expanded_path
        end
      end
    end

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
