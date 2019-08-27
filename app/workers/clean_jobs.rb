class CleanJobs
  include Sidekiq::Worker
  sidekiq_options queue: AsyncRequest.config[:queue], retry: AsyncRequest.config[:retry]

  def perform
    jobs.destroy_all
  end

  private

  def jobs
    AsyncRequest::Job.where('ended_at < ?', AsyncRequest.config[:jobs_expiration].hours.ago)
  end
end
