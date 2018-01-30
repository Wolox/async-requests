module AsyncRequest
  class Job < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
    serialize :params, Array
    enum status: { waiting: 0, processing: 1, processed: 2, failed: 3 }

    def self.create_and_enqueue(worker_class, *params)
      raise ArgumentError if worker_class.nil?
      create(
        worker: worker_class,
        params: params,
        status: statuses[:waiting],
        uid: SecureRandom.uuid
      ).tap { |job| JobProcessor.perform_async(job.id) }
    end

    def token
      @token ||= JsonWebToken.encode(id)
    end

    def successfully_processed!(response, status_code)
      Rails.logger.info("Processing finished successfully for job with id=#{id}")
      update_attributes!(
        status: :processed,
        status_code: map_status_code(status_code),
        response: response.to_s
      )
    end

    def processing!
      Rails.logger.info("Processing job with id=#{id}")
      super
    end

    def finished?
      processed? || failed?
    end

    def finished_with_errors!(error)
      Rails.logger.info("Processing failed for job with id=#{id}")
      Rails.logger.info(error.message)
      Rails.logger.info(error.backtrace.inspect)
      update_attributes!(status: :failed, status_code: 500,
                         response: { error: error.message }.to_json)
    end

    private

    def map_status_code(status_code)
      return Rack::Utils::SYMBOL_TO_STATUS_CODE[status_code] if status_code.is_a?(Symbol)
      status_code.to_i
    end
  end
end
