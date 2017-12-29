class DummyController < ApplicationController
  def async_option_1
    job = AsyncRequest::Job.create_and_enqueue(WorkerWithoutErrors)
    render json: { token: job.token, url: async_request.job_url }, status: 202
  end

  def async_option_2
    job = AsyncRequest::Job.create_and_enqueue(WorkerWithoutErrors)
    render json: { token: job.token }, status: 202, location: async_request.job_url
  end
end
