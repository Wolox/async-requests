module AsyncRequest
  class JobsController < ActionController::Base
    def show
      return render_invalid_token unless valid_token?
      job = Job.find_by(token[:job_id])
      return head :not_found unless job.present?
      job.processed? ? render_finished_job(job) : render_pending(job)
    end

    private

    def valid_token?
      token[:job_id].present? && token[:expires_in] > Time.zone.now
    end

    def token
      @token ||= decode_token
    end

    def decode_token
      JWT.decode(request.headers['Authorization'].split(' ').last).first
    rescue
      {}
    end

    def render_invalid_token
      render json: { errors: [{ message: 'Invalid token' }] }, status: :bad_request
    end

    def render_pending(job)
      render json: { status: job.status }, status: :accepted
    end

    def render_finished_job(job)
      render json: { status: job.status_code, response: JSON.parse(job.response) }, status: :ok
    end
  end
end
