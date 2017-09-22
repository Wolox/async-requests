class WorkerWithoutErrors
  def execute(*params)
    [200, { message: 'success' }]
  end
end
