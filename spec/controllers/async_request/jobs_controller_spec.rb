require 'spec_helper'

describe AsyncRequest::JobsController do
  routes { AsyncRequest::Engine.routes }

  describe '#show' do
    let(:job) { create(:async_request_job, status) }
    let(:job_id) { job.id }
    let(:job_token) { AsyncRequest::JsonWebToken.encode(job_id) }
    let(:status) { :waiting }

    before { request.headers['X-JOB-AUTHORIZATION'] = "Bearer #{job_token}" }

    context 'when there is no job with the given id' do
      let(:job_id) { 1000 }

      it 'returns status not found' do
        get :show
        expect(response).to have_http_status :not_found
      end
    end

    context 'when receiving an expired token' do
      let(:job_token) do
        AsyncRequest::JsonWebToken.encode(create(:async_request_job).id, (1.day * -1).to_i)
      end

      it 'returns status bad request' do
        get :show
        expect(response).to have_http_status :bad_request
      end
    end

    context 'when the job exists but it is in a waiting status' do
      it 'returns status accepted' do
        get :show
        expect(response).to have_http_status :accepted
      end
    end

    context 'when the job exists but it is in a processing status' do
      let(:status) { :processing }

      it 'returns status accepted' do
        get :show
        expect(response).to have_http_status :accepted
      end
    end

    context 'when the job exists and has finished' do
      let(:status) { :processed }

      it 'returns the saved status code' do
        get :show
        expect(response).to have_http_status :ok
      end

      it 'returns as body job\'s status code and response' do
        get :show
        controller_response = {
          'status' => 'processed',
          'response' => { 'status_code' => job.status_code, 'body' => job.response }
        }
        expect(response_body).to eq(controller_response)
      end
    end

    context 'when the job exists and has a failed status' do
      let(:status) { :failed }

      it 'returns the saved status code' do
        get :show
        expect(response).to have_http_status :ok
      end

      it 'returns as body job\'s status code and response' do
        get :show
        controller_response = {
          'status' => 'failed',
          'response' => { 'status_code' => job.status_code, 'body' => job.response }
        }
        expect(response_body).to eq(controller_response)
      end
    end
  end
end
