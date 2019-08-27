require 'async_request/engine'

module AsyncRequest
  VALID_ALGORITHMS = %w[HS256 RS256].freeze

  @config = {
    sign_algorithm: 'HS256',
    encode_key: nil,
    decode_key: nil,
    token_expiration: 86_400,
    request_header_key: 'X-JOB-AUTHORIZATION',
    queue: 'default',
    jobs_expiration: 24,
    clean_jobs_cron: '0 0 * * *',
    clean_jobs: true,
    retry: false
  }

  def self.configure
    yield self
  end

  def self.sign_algorithm=(sign_algorithm)
    raise ArgumentError unless VALID_ALGORITHMS.include?(sign_algorithm)
    @config[:sign_algorithm] = sign_algorithm
  end

  def self.encode_key=(encode_key)
    @config[:encode_key] = encode_key
  end

  def self.decode_key=(decode_key)
    @config[:decode_key] = decode_key
  end

  def self.token_expiration=(token_expiration)
    @config[:token_expiration] = token_expiration
  end

  def self.jobs_expiration=(jobs_expiration)
    @config[:jobs_expiration] = jobs_expiration
  end

  def self.clean_jobs_cron=(clean_jobs_cron)
    @config[:clean_jobs_cron] = clean_jobs_cron
  end

  def self.clean_jobs=(clean_jobs)
    @config[:clean_jobs] = clean_jobs
  end

  def self.request_header_key=(request_header_key)
    @config[:request_header_key] = request_header_key
  end

  def self.queue=(queue)
    @config[:queue] = queue
  end

  def self.retry=(retry_times)
    raise ArgumentError unless [true, false].include?(retry_times) || retry_times.is_a?(Integer)
    @config[:retry] = retry_times
  end

  def self.config
    @config
  end
end
