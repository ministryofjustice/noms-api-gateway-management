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
    response.is_a?(Exception) ? parse_exception(response) : parse_data(response.data)
  end

  def parse_data(data)
    data.is_a?(Hash) ? data : "#{parsed_response.code}#{': ' + data.truncate(30) if data }"
  end

  def parse_exception(response)
    case response
      when SocketError then 'Environment does not exist'
      when SSLError    then 'SSL Error'
      else 'Unexpected error'
    end
  end

  def set_code(response)
    response.is_a?(Exception) ? code_for_exception(response) : response.raw_response.code.to_i
  end

  def code_for_exception(response)
    case response
      when SocketError then 404
      when SSLError    then 525
      else 'Unexpected error'
    end
  end
end
