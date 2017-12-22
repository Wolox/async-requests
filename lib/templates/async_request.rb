AsyncRequest.configure do |config|
  config.encode_key = Rails.application.secrets.secret_key_base
  config.decode_key = Rails.application.secrets.secret_key_base
  config.token_expiration = Time.zone.now + 1.day
end
