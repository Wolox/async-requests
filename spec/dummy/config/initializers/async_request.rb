AsyncRequest.configure do |config|
  config.encode_key = Rails.application.secrets.secret_key_base
  config.decode_key = Rails.application.secrets.secret_key_base
  config.clean_jobs_cron = Rails.application.secrets.clean_jobs_cron || '* * * * *'
  config.jobs_expiration = (Rails.application.secrets.jobs_expiration || 24).to_i
  config.clean_jobs = if Rails.env.test? 
                        false
                      elsif Rails.application.secrets.clean_jobs.present?
                        Rails.application.secrets.clean_jobs
                      else
                        true
                      end
  config.token_expiration = 1.day
end

if AsyncRequest.config[:clean_jobs] && Rails.const_defined?('Server')
  Sidekiq::Cron::Job
    .create(name: 'Clean Jobs', cron: AsyncRequest.config[:clean_jobs_cron], class: CleanJobs)
end
