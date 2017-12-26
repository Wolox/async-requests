require 'spec_helper'

module AsyncRequest
  describe JobProcessor do
    describe '#perform' do
      let(:job) { AsyncRequest::Job.create_and_enqueue(worker, { a: 'a' }, 3, 'a') }

      context 'when executing the worker' do
        context 'when it finishes without errors' do
          let(:worker) { WorkerWithoutErrors }

          it 'calls Test class' do
            expect_any_instance_of(worker).to receive(:execute).with({ a: 'a' }, 3, 'a')
            described_class.new.perform(job.id)
          end

          it 'saves the worker status code' do
            described_class.new.perform(job.id)
            expect(job.reload.status_code).to eq 200
          end

          it 'saves the worker response' do
            described_class.new.perform(job.id)
            expect(job.reload.response).to eq({ 'message' => 'success' }.to_json)
          end
        end

        context 'when the worker returns a symbol' do
          let(:worker) { WorkerWithSymbol }

          it 'saves the worker status code' do
            described_class.new.perform(job.id)
            expect(job.reload.status_code).to eq 200
          end
        end

        context 'when it raises an error' do
          let(:worker) { WorkerWithErrors }

          it 'updates the job with the right status' do
            described_class.new.perform(job.id)
            expect(job.reload.failed?).to be_truthy
          end

          it 'saves the job with a 500 as status code' do
            described_class.new.perform(job.id)
            expect(job.reload.status_code).to eq 500
          end
        end
      end
    end
  end
end
