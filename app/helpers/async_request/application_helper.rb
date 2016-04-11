module AsyncRequest
  module ApplicationHelper
    def execute_async(worker_class, *params)
      job = Job.create(
        worker: worker_class,
        params: params,
        status: Job.statuses[:waiting],
        uid: SecureRandom.uuid
      )
      JobProcessor.perform_async(job.id)
      job.uid
    end
  end
end
