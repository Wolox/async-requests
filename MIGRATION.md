# Migration guide

## From 0.x.x to 1.0.0

On the backend side the changes are simple:

1. Remove the `AsyncRequest::ApplicationHelper` from your controller.
2. The gem does not expect a JSON as the result of the worker anymore (but a string instead). So if you were returning JSON objects from your worker, you have to call `.to_json` before:
```ruby
class MyComputeHeavyWorker
  def execute(options, string)
    # Perform heavy task
    [:ok, { message: 'success' }.to_json]
  end
end
```
3. The `execute_async(MyComputeHeavyWorker, arg)` method was removed, instead you have to call `AsyncRequest::Job.create_and_enqueue(MyComputeHeavyWorker, arg)`. This will return the new `AsyncRequest::Job` instance.
4. Since the endpoint to check the job result is now authenticated, you have to return the token needed when a job is created. You can do something like `render json: { token: job.token, url: async_request.job_url }, status: :accepted`.
5. You will need to add a configuration file:
``` ruby
# config/initializers/async_request.rb
AsyncRequest.configure do |config|
  config.sign_algorithm = 'HS256' # This is the default, valid algorithms: HS256 and RS256
  config.request_header_key = 'X-JOB-AUTHORIZATION' # This is the default
  config.encode_key = Rails.application.secrets.secret_key_base # This is needed or you will get an error
  config.decode_key = Rails.application.secrets.secret_key_base # This is needed or you will get an error
  config.token_expiration = 1.day # This is the default
end
```

Now on the frontend side the changes are this:

1. Since we don't force you to store a JSON in the database, if you were expecting one in the frontend now you must parse the string returned yourself `JSON.parse(response.body)`.
2. Since checking for job status now is authenticated with the token created, you have to make the request sending the token returned in a HTTP header, you don't have to send the job_id anymore.
3. When checking for the result of the job, now the endpoint returns either accepted (202) or ok (200), the actual status code of the worker is in `response.status_code`.
