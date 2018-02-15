module AsyncRequest
  class JobProcessor
    include Sidekiq::Worker
    sidekiq_options queue: AsyncRequest.config[:queue], retry: AsyncRequest.config[:retry]

    def perform(id)
      job = Job.find(id)
      job.processing!
      status, response = job.worker.constantize.new.execute(*job.params)
      job.update_attributes!(
        status: Job.statuses[:processed],
        status_code: status,
        response: response.to_json
      )
    end
  end
end
