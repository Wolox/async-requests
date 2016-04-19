Rails.application.routes.draw do
  get :async, to: 'application#test'
  get :normal, to: 'application#normal'
end
