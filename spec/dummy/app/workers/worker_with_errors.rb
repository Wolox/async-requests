class WorkerWithErrors
  def execute(params)
    raise SomeError
  end

  class SomeError < StandardError

  end
end
