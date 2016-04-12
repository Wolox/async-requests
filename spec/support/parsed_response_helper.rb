module Response
  module JSONParser
    def response_body
      ActiveSupport::JSON.decode(response.body) if response.present?
    end
  end
end
