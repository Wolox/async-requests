require 'spec_helper'

describe DummyController, type: :controller do
  describe '.async_option_1' do
    subject(:request) { post :async_option_1 }

    it 'returns status code accepted' do
      request
      expect(response).to have_http_status(:accepted)
    end

    it 'creates the job model' do
      expect { request }.to change { AsyncRequest::Job.count }.by(1)
    end

    it 'returns the url' do
      request
      expect(response_body['url']).to be_present
    end

    it 'returns the token' do
      request
      expect(response_body['token']).to be_present
    end
  end

  describe '.async_option_2' do
    subject(:request) { post :async_option_2 }

    it 'returns status code accepted' do
      request
      expect(response).to have_http_status(:accepted)
    end

    it 'creates the job model' do
      expect { request }.to change { AsyncRequest::Job.count }.by(1)
    end

    it 'returns the token' do
      request
      expect(response_body['token']).to be_present
    end

    it 'returns the location header' do
      request
      expect(response.headers['Location']).to be_present
    end
  end
end
