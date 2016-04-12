# AsyncRequest
[![Code Climate](https://codeclimate.com/github/mdesanti/async-requests/badges/gpa.svg)](https://codeclimate.com/github/mdesanti/async-requests)[![Test Coverage](https://codeclimate.com/github/mdesanti/async-requests/badges/coverage.svg)](https://codeclimate.com/github/mdesanti/async-requests/coverage)[![Build Status](https://travis-ci.org/mdesanti/async-requests.svg?branch=master)](https://travis-ci.org/mdesanti/async-requests)

### Summary
At [Wolox](http://www.wolox.com.ar) we build Rails Apps. Some of them need heavy computing when a request is received. In order to make the App scalable, we perform those heavy actions in background. We return a job-id and the client asks for it's state a few seconds after.

`async_request` gives us the possibility of handling these type of requests in a simple way.

### Installation

Add `gem 'async_request'` to your gemfile

### Usage

Simply call `async_request(your_worker, *args)` like this:

``` ruby
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def my_compute_heavy_endpoint
    id = execute_async(MyComputeHeavyWorker, { some: 'args' }, 'another arg')
    render json: { id: id, url: async_request.job_url(id) }, status: 202
  end
end
```
This will enqueue a Sidekiq task that will call `MyComputeHeavyWorker.new.execute` with the args passed as parameters to `execute_async`.

The client can then make a GET request to the returned URL. If the job's completed, it will get a response code and a json body. Otherwise, a `202` code will be returned

`MyComputeHeavyWorker` must return an array with two components. The first one must be the status code, the second one must be the response that will be sent to the client. Take into account that the response must respond to `to_json`.


## About ##

This project is maintained by [Matías De Santi](https://github.com/mdesanti) and it was written by [Wolox](http://www.wolox.com.ar).

![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)


## License

**AsyncRequest** is available under the MIT [license](https://raw.githubusercontent.com/mdesanti/async-requests/master/LICENSE).

    Copyright (c) 2016 Matías De Santi <matias.desanti@wolox.com.ar>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
