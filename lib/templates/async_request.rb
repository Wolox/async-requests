AsyncRequest.configure do |config|
  config.encode_key = Rails.application.secrets.secret_key_base
  config.decode_key = Rails.application.secrets.secret_key_base
  config.token_expiration = 1.day
end
