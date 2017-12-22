require 'spec_helper'

describe AsyncRequest::Job do
  describe '.execute_async' do
    let(:worker) { WorkerWithoutErrors }

    context 'when no worker class is passed' do
      it 'fails with ArgumentError' do
        expect { described_class.execute_async(nil, []) }.to raise_error(ArgumentError)
      end
    end

    context 'when called with valid params' do
      it 'creates a new job object' do
        expect { described_class.execute_async(worker, 'a') }
          .to change { described_class.count }.by(1)
      end

      it 'creates a new job object with WorkerWithoutErrors as worker' do
        job, _token = described_class.execute_async(worker, 'a')
        expect(job.worker).to eq worker.to_s
      end

      it "creates a new job object with ['a'] as params" do
        job, _token = described_class.execute_async(worker, 'a')
        expect(job.params).to eq ['a']
      end

      it 'creates a new job object with waiting status' do
        job, _token = described_class.execute_async(worker, 'a')
        expect(job.waiting?).to be_truthy
      end

      it 'serializes complex params' do
        job, _token = described_class.execute_async(worker, { a: 'a' }, 3, 'a')
        expect(job.params).to eq [{ a: 'a' }, 3, 'a']
      end
    end
  end
end
