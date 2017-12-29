class WorkerWithSymbol
  def execute(*_params)
    [:ok, { message: 'success' }.to_json]
  end
end
