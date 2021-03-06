require 'jwt'
require 'time'

module AsyncRequest
  class JsonWebToken
    def self.encode(job_id, expiration = AsyncRequest.config[:token_expiration].to_i)
      JWT.encode(
        {
          job_id: job_id,
          expires_in: (Time.zone.now + expiration).to_i
        },
        AsyncRequest.config[:encode_key],
        AsyncRequest.config[:sign_algorithm]
      )
    end

    def self.decode(token)
      JWT.decode(
        token,
        AsyncRequest.config[:decode_key],
        true,
        algorithm: AsyncRequest.config[:sign_algorithm]
      ).first
    end
  end
end
