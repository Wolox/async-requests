class WorkerWithErrors
  def execute(_params)
    raise SomeError
  end

  class SomeError < StandardError
  end
end
