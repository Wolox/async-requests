class CleanJobs
  include Sidekiq::Worker
  sidekiq_options queue: AsyncRequest.config[:queue], retry: AsyncRequest.config[:retry]

  def perform
    jobs =
      AsyncRequest::Job
      .where('ended_at < ?',Rails.application.secrets.expiration_time_jobs.hours.ago)
    jobs.destroy_all
  end
end
