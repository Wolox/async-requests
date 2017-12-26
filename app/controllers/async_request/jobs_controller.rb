require 'jwt'

module AsyncRequest
  class JobsController < ActionController::Base
    def show
      return render_invalid_token unless valid_token?
      job = Job.find_by(id: token[:job_id])
      return head :not_found if job.blank?
      job.finished? ? render_finished_job(job) : render_pending
    end

    private

    def valid_token?
      token[:job_id].present? && Time.zone.now.to_i < token[:expires_in]
    end

    def token
      @token ||= decode_token
    end

    def decode_token
      HashWithIndifferentAccess.new(
        JsonWebToken.decode(
          request.headers[AsyncRequest.config[:request_header_key]].split(' ').last
        )
      )
    rescue StandardError
      {}
    end

    def render_invalid_token
      render json: { errors: [{ message: 'Invalid token' }] }, status: :bad_request
    end

    def render_pending
      head :accepted
    end

    def render_finished_job(job)
      render json: {
        status: job.status,
        response: {
          status_code: job.status_code, body: job.response
        }
      }, status: :ok
    end
  end
end
