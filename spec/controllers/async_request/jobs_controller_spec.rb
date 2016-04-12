require 'spec_helper'

module AsyncRequest
  describe JobsController do
    routes { AsyncRequest::Engine.routes }

    describe '#show' do
      context 'when there is no job with the given id' do
        let!(:job) { FactoryGirl.create(:async_request_job, :waiting) }
        it 'returns 404' do
          get :show, id: job.uid + 'ABC'
          expect(response.status).to eq(404)
        end
      end

      context 'when the job exists but it is in a waiting status' do
        let!(:job) { FactoryGirl.create(:async_request_job, :waiting) }
        it 'returns 202' do
          get :show, id: job.uid
          expect(response.status).to eq(202)
        end
      end

      context 'when the job exists but it is in a processing status' do
        let!(:job) { FactoryGirl.create(:async_request_job, :processing) }
        it 'returns 202' do
          get :show, id: job.uid
          expect(response.status).to eq(202)
        end
      end

      context 'when the job exists and has finished' do
        let!(:job) { FactoryGirl.create(:async_request_job, :processed) }

        it 'returns the saved status code' do
          get :show, id: job.uid
          expect(response.status).to eq(job.status_code)
        end

        it 'returns the saved status code' do
          get :show, id: job.uid
          expect(response_body).to eq(JSON.parse(job.response))
        end
      end
    end
  end
end
