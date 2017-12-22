class DummyController < ApplicationController
  def async_option_1
    _job, token = AsyncRequest::Job.execute_async(WorkerWithoutErrors)
    render json: { token: token, url: async_request.job_url }, status: 202
  end

  def async_option_2
    _job, token = AsyncRequest::Job.execute_async(WorkerWithoutErrors)
    render json: { token: token }, status: 202, location: async_request.job_url
  end
end
