Rails.application.routes.draw do
  get :async, to: 'application#test'
end
