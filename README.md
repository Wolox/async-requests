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

This gem provides a [Sidekiq worker](https://github.com/Wolox/async-requests/blob/master/app/workers/async_request/job_processor.rb) that will call an instance method named `execute` of any given class and store the response in the database. In order to do this, we provide a model named `AsyncRequest::Job` that will handle the queue of the worker with the params.

* IMPORTANT: The response of the worker will store the response as a string and the status code as an integer.

``` ruby
class SomeController < ApplicationController
  def my_compute_heavy_endpoint_option_1
    job = AsyncRequest::Job.create_and_enqueue(MyComputeHeavyWorker, { some: 'args' }, 'another arg')
    render json: { token: job.token, url: async_request.job_url }, status: :accepted
  end

  def my_compute_heavy_endpoint_option_2
    job = AsyncRequest::Job.create_and_enqueue(MyComputeHeavyWorker, { some: 'args' }, 'another arg')
    render json: { token: job.token }, status: :accepted, location: async_request.job_url
  end
end

class MyComputeHeavyWorker
  def execute(options, string)
    # Perform heavy task
    [:ok, { message: 'success' }.to_json] # returning 200 is valid too
  end
end
```

This will enqueue a `JobProcessor` worker that will call `MyComputeHeavyWorker.new.execute` with the args passed as parameters to `create_and_enqueue`.

The client can then make a GET request to the returned URL sending the `token` in a `X-JOB-AUTHORIZATION` header (configurable). If the job's completed, it will get a response code and a json body. Otherwise, a HTTP status code `accepted (202)` will be returned.

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
  config.clean_jobs_cron = Rails.application.secrets.clean_jobs_cron # Optional, default: every day
  config.jobs_expiration = Rails.application.secrets.jobs_expiration # Optional, default: 24 hours
  config.clean_jobs = Rails.application.secrets.clean_jobs # Optional, default: true
  config.token_expiration = 1.day
end

```

## Migration

If you were using an older version of the gem and would like to migrate, check our [migration guide](https://raw.githubusercontent.com/mdesanti/async-requests/master/MIGRATION.md)

## About ##

This project is maintained by [Alejandro Bezdjian](https://github.com/alebian) and [Alan Halatian](https://github.com/alanhala) and it was written by [Wolox](http://www.wolox.com.ar).

![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)

## License

**AsyncRequest** is available under the MIT [license](https://raw.githubusercontent.com/mdesanti/async-requests/master/LICENSE).
