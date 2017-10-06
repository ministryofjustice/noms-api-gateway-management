class ExceptionSafeResponseParser
  
  attr_accessor :parsed_response

  def initialize
    @parsed_response = OpenStruct.new(code: nil, data: nil)
  end

  def parse(response)
    parsed_response.code = set_code(response)
    parsed_response.data = set_data(response)
    parsed_response
  end

  private

  def set_data(response)
    response.is_a?(SocketError) ? error_message : parse_data(response.data)
  end

  def parse_data(data)
    data.is_a?(Hash) ? data : "#{parsed_response.code}#{': ' + data.truncate(30) if data }"
  end

  def set_code(response)
    response.is_a?(SocketError) ? 404 : response.raw_response.code.to_i
  end

  def error_message
    'Environment does not exist'
  end
end
