require 'jwt'

module AsyncRequest
  class JsonWebToken
    def self.encode(job_id, expiration = Time.zone.now + 1.day)
      JWT.encode(
        { job_id: job_id, expires_in: expiration },
        Rails.application.secrets.secret_key_base
      )
    end

    def self.decode(token)
      JWT.decode(token, Rails.application.secrets.secret_key_base)
    end
  end
end
