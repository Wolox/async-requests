module AsyncRequest
  class JobProcessor
    include Sidekiq::Worker
    sidekiq_options queue: AsyncRequest.config[:queue], retry: AsyncRequest.config[:retry]

    def perform(id)
      job = Job.find(id)
      job.processing!
      begin
        status, response = job.worker.constantize.new.execute(*job.params)
        job.successfully_processed!(response, status)
      rescue StandardError
        job.finished_with_errors!
      end
    end
  end
end
