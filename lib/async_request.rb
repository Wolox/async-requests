require 'async_request/constants'
require 'async_request/engine'

module AsyncRequest
  VALID_ALGORITHMS = %w[HS256 RS256].freeze

  @config = {
    sign_algorithm: 'HS256',
    encode_key: 'CHANGE_ME_IN_THE_INITIALIZER_FILE',
    decode_key: 'CHANGE_ME_IN_THE_INITIALIZER_FILE',
    token_expiration: 1_829_484_000,
    request_header_key: 'X-JOB-AUTHORIZATION'
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

  def self.request_header_key=(request_header_key)
    @config[:request_header_key] = request_header_key
  end

  def self.config
    @config
  end
end
