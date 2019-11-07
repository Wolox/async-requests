require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  post :async_option_1, to: 'dummy#async_option_1'
  post :async_option_2, to: 'dummy#async_option_2'
end
