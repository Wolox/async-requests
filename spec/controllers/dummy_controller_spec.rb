require 'spec_helper'

describe DummyController, type: :controller do
  describe '.async_option_1' do
    subject { post :async_option_1 }

    it 'returns status code accepted' do
      subject
      expect(response).to have_http_status(:accepted)
    end

    it 'creates the job model' do
      expect { subject }.to change { AsyncRequest::Job.count }.by(1)
    end

    it 'returns the url' do
      subject
      expect(response_body['url']).to be_present
    end

    it 'returns the token' do
      subject
      expect(response_body['token']).to be_present
    end
  end

  describe '.async_option_2' do
    subject { post :async_option_2 }

    it 'returns status code accepted' do
      subject
      expect(response).to have_http_status(:accepted)
    end

    it 'creates the job model' do
      expect { subject }.to change { AsyncRequest::Job.count }.by(1)
    end

    it 'returns the token' do
      subject
      expect(response_body['token']).to be_present
    end

    it 'returns the location header' do
      subject
      expect(response.headers['Location']).to be_present
    end
  end
end
