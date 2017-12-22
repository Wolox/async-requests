module Helpers
  def job_id_from_token(token)
    AsyncRequest::JsonWebToken.decode(token)['job_id']
  end
end
