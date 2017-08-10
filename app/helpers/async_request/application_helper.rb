module AsyncRequest
  module_function

  def execute_async(worker_class, *params)
    raise ArgumentError if worker_class.nil?
    job = Job.create(
      worker: worker_class,
      params: params,
      status: Job.statuses[:waiting],
      uid: SecureRandom.uuid
    )
    JobProcessor.perform_async(job.id)
    JWT.encode(
      { job_id: job.uid, expires_in: Time.zone.now + 1.day },
      Rails.application.secrets.secret_key_base
    )
  end
end
