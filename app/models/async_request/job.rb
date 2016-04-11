module AsyncRequest
  class Job < ActiveRecord::Base
    serialize :params, Array
    enum status: [:wating, :processing, :processed]
  end
end
