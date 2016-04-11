module AsyncRequest
  class JobProcessor
    include Sidekiq::Worker

    def perform(id)
      job = Job.find(id)
      job.processing!
      status, response = job.worker.constantize.new.execute(job.params)
      job.update_attributes!(
        status: Job.statuses[:processed],
        status_code: status,
        response: response
      )
    end
  end
end
