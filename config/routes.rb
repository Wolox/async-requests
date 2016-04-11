AsyncRequest::Engine.routes.draw do
  resources :jobs, only: [:show]
end
