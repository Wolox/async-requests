class WorkerReturningNil
  def execute(*_params)
    [:bad_request, nil]
  end
end
