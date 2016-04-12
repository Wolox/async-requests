require 'spec_helper'

module AsyncRequest
  describe JobProcessor do
    include AsyncRequest::Engine.helpers
    describe '.perform' do
      let(:uid) { execute_async(Test, { a: 'a' }, 3, 'a') }

      before(:each) do
        Test.any_instance.stub(:execute).and_return([200, { status: 'success' }])
      end

      context 'When executing the worker' do
        it 'calls Test class' do
          expect_any_instance_of(Test).to receive(:execute).with({ a: 'a' }, 3, 'a')
          JobProcessor.new.perform(Job.find_by(uid: uid).id)
        end

        it 'saves the worker status code' do
          JobProcessor.new.perform(Job.find_by(uid: uid).id)
          expect(Job.find_by(uid: uid).status_code).to eq 200
        end

        it 'saves the worker response' do
          JobProcessor.new.perform(Job.find_by(uid: uid).id)
          response = Job.find_by(uid: uid).response
          expect(response).to eq({ status: 'success' }.to_json)
        end
      end
    end
  end
end
