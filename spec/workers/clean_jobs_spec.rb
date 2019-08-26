require 'spec_helper'

describe CleanJobs do
  describe '#perform' do
    context 'when there are jobs to be deleted' do
      let(:expired_job) do
        create(:async_request_job, created_at: 48.hours.ago, ended_at: 47.hours.ago)
      end

      let(:not_expired_job) do
        create(:async_request_job, created_at: 2.minutes.ago, ended_at: 1.minute.ago)
      end

      before do
        expired_job
      end

      it 'should deleted the expired job' do
        expect { described_class.new.perform }.to change { AsyncRequest::Job.count }.by(-1)
      end
    end
  end
end
