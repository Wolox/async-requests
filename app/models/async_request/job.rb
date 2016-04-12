module AsyncRequest
  class Job < ActiveRecord::Base
    serialize :params, Array
    enum status: [:waiting, :processing, :processed]
  end
end
