class WorkerWithoutErrors
  def execute(*_params)
    [200, { message: 'success' }.to_json]
  end
end
