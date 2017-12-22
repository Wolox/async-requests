class WorkerWithoutErrors
  def execute(*_params)
    [200, { message: 'success' }]
  end
end
