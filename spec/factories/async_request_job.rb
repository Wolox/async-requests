FactoryGirl.define do
  factory :async_request_job, class: 'AsyncRequest::Job' do
    worker { Faker::Lorem.word }
    status_code 200
    response { { a: Faker::Lorem.word, b: Faker::Lorem.word, c: Faker::Lorem.word }.to_json }
    uid { Faker::Lorem.word }
    params [Faker::Lorem.word, { a: 'a' }]
    ended_at { 10.seconds.from_now }
  end

  trait :waiting do
    status ::AsyncRequest::Job.statuses[:waiting]
  end

  trait :processing do
    status ::AsyncRequest::Job.statuses[:processing]
  end

  trait :processed do
    status ::AsyncRequest::Job.statuses[:processed]
  end

  trait :failed do
    status ::AsyncRequest::Job.statuses[:failed]
    status_code 500
    response { {} }
  end
end

