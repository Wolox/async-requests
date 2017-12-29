Rails.application.routes.draw do
  post :async_option_1, to: 'dummy#async_option_1'
  post :async_option_2, to: 'dummy#async_option_2'
end
