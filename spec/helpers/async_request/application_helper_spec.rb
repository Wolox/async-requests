require 'spec_helper'

module AsyncRequest
  describe ApplicationHelper do
    describe '.execute_async' do
      context 'When no worker class is passed' do
        it 'fails with ArgumentError' do
          expect { execute_async(nil, []) }.to raise_error(ArgumentError)
        end
      end

      context 'When called with valid params' do
        it 'creates a new job object' do
          expect { execute_async(Test, 'a') }.to change { Job.count }.by(1)
        end

        it 'creates a new job object with Test as worker' do
          job = Job.find_by(uid: execute_async(Test, 'a'))
          expect(job.worker).to eq 'Test'
        end

        it 'creates a new job object with [\'a\'] as params' do
          job = Job.find_by(uid: execute_async(Test, 'a'))
          expect(job.params).to eq ['a']
        end

        it 'creates a new job object with [\'a\'] as params' do
          job = Job.find_by(uid: execute_async(Test, 'a'))
          expect(job.waiting?).to be_truthy
        end

        it 'serializes complex params' do
          job = Job.find_by(uid: execute_async(Test, { a: 'a' }, 3, 'a'))
          expect(job.params).to eq [{ a: 'a' }, 3, 'a']
        end
      end
    end
  end
end
