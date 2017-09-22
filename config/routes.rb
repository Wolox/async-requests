AsyncRequest::Engine.routes.draw do
  resource :job, only: [:show]
end
