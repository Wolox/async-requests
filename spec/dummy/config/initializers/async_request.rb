AsyncRequest.configure do |config|
  config.encode_key = Rails.application.secrets.secret_key_base
  config.decode_key = Rails.application.secrets.secret_key_base
  config.clean_jobs_cron = Rails.application.secrets.clean_jobs_cron || '0 0 * * *'
  config.jobs_expiration = Rails.application.secrets.jobs_expiration.to_i || 24
  config.clean_jobs = Rails.application.secrets.clean_jobs || true
  config.token_expiration = 1.day
end

if AsyncRequest.config[:clean_jobs] && !Rails.env.test?
  Sidekiq::Cron::Job
    .create(name: 'Clean Jobs', cron: AsyncRequest.config[:clean_jobs_cron], class: CleanJobs)
end
