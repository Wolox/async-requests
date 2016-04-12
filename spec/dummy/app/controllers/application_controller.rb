class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def async
    id = execute_async(Test, 'a')
    render json: { id: id, url: async_request.job_url(id) }, status: 202
  end
end
