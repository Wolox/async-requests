# AsyncRequest
[![Gem Version](https://badge.fury.io/rb/async-requests.svg)](https://badge.fury.io/rb/async-requests)
[![Build Status](https://travis-ci.org/Wolox/async-requests.svg?branch=master)](https://travis-ci.org/Wolox/async-requests)
[![Code Climate](https://codeclimate.com/github/mdesanti/async-requests/badges/gpa.svg)](https://codeclimate.com/github/mdesanti/async-requests)
[![Test Coverage](https://codeclimate.com/github/mdesanti/async-requests/badges/coverage.svg)](https://codeclimate.com/github/mdesanti/async-requests/coverage)

### Summary

When developing Rails (or other) apps you find some tasks that need to run on the background to make the application more scalable. We normally use Sidekiq to execute these background jobs, but often we need to perform tasks that clients need the response, `async_request` gives us the possibility of handling these type of tasks in a simple way.

### Installation

Add `gem 'async_request'` to your gemfile

Run `rails g async_request`

### Usage

This gem provides a  that will call an `execute` a method of any class you give and will store the response in the database. In order to do this, we provide a model named `AsyncRequest::Job` that will handle the queue of the worker with the params.

* IMPORTANT: The response of the worker will store the response as a string and the status code as an integer.

``` ruby
class SomeController < ApplicationController
  def my_compute_heavy_endpoint_option_1
    _job, token = AsyncRequest::Job.execute_async(MyComputeHeavyWorker, { some: 'args' }, 'another arg')
    render json: { token: token, url: async_request.job_url }, status: :accepted
  end

  def my_compute_heavy_endpoint_option_2
    _job, token = AsyncRequest::Job.execute_async(MyComputeHeavyWorker, { some: 'args' }, 'another arg')
    render json: { token: token }, status: :accepted, location: async_request.job_url
  end
end

class MyComputeHeavyWorker
  def execute(options, string)
    # Perform heavy task
    [:ok, { message: 'success' }.to_json] # returning 200 is valid too
  end
end
```

This will enqueue a [Sidekiq worker](https://github.com/Wolox/async-requests/blob/master/app/workers/async_request/job_processor.rb) that will call `MyComputeHeavyWorker.new.execute` with the args passed as parameters to `execute_async`.

The client can then make a GET request to the returned URL sending the `token` in a `X-JOB-AUTHORIZATION` header (configurable). If the job's completed, it will get a response code and a json body. Otherwise, a `202 (accepted)` code will be returned.

`MyComputeHeavyWorker` must return an array with two components. The first one has be the status code (number or Rails symbol), the second one has be the response that will be sent to the client. Take into account that the response must be a string because it will be stored in the database.

### Configuration

There are some aspects of the gem you can configure:

``` ruby
# config/initializers/async_request.rb
AsyncRequest.configure do |config|
  config.sign_algorithm = 'HS256' # This is the default, valid algorithms: HS256 and RS256
  config.request_header_key = 'X-JOB-AUTHORIZATION' # This is the default
  config.encode_key = Rails.application.secrets.secret_key_base
  config.decode_key = Rails.application.secrets.secret_key_base
  config.token_expiration = Time.zone.now + 1.day
end

```

## About ##

This project is maintained by [Matías De Santi](https://github.com/mdesanti) and it was written by [Wolox](http://www.wolox.com.ar).

![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)

## License

**AsyncRequest** is available under the MIT [license](https://raw.githubusercontent.com/mdesanti/async-requests/master/LICENSE).
