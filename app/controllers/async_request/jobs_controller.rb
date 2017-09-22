require 'jwt'

module AsyncRequest
  class JobsController < ActionController::Base
    def show
      return render_invalid_token unless valid_token?
      job = Job.find_by_id(token[:job_id])
      return head :not_found unless job.present?
      job.finished? ? render_finished_job(job) : render_pending(job)
    end

    private

    def valid_token?
      token[:job_id].present? && token[:expires_in] > Time.zone.now
    end

    def token
      @token ||= decode_token
    end

    def decode_token
      HashWithIndifferentAccess.new(
        JWT.decode(
          request.headers['Job_Authorization'].split(' ').last,
          Rails.application.secrets.secret_key_base
        ).first
      )
    rescue
      {}
    end

    def render_invalid_token
      render json: { errors: [{ message: 'Invalid token' }] }, status: :bad_request
    end

    def render_pending(_job)
      head :accepted
    end

    def render_finished_job(job)
      render json: {
        status: job.status,
        response: {
          status_code: job.status_code, body: JSON.parse(job.response)
        }
      }, status: :ok
    end
  end
end
