require 'async_request/engine'

module AsyncRequest
  @config = {
    queue: 'default',
    retry: false
  }

  def self.configure
    yield self
  end

  def self.queue=(queue)
    @config[:queue] = queue
  end

  def self.retry=(retry_times)
    raise ArgumentError unless [true, false].include?(retry_times) || retry_times.is_a?(Integer)
    @config[:retry] = retry_times
  end

  def self.config
    @config
  end
end
