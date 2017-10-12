class ExceptionSafeResponseParser
  
  attr_accessor :parsed_response, :logger

  def initialize
    @parsed_response = OpenStruct.new(code: nil, data: nil)
    log_file = Rails.root.join("./log/#{Rails.env}.log")
    @logger = Logger.new(log_file)
  end

  def parse(response)
    parsed_response.code = set_code(response)
    parsed_response.data = set_data(response)
    parsed_response
  end

  private

  def set_data(response)
    response.is_a?(Exception) ? handle_exception(response) : parse_data(response.data)
  end

  def parse_data(data)
    data.is_a?(Hash) ? data : "#{parsed_response.code}#{': ' + data.truncate(30) if data }"
  end

  def handle_exception(response)

    logger.level = Logger::ERROR
    logger.error(response)

    case response
    when SocketError
      'Environment does not exist'
    when SSLError 
      'SSL Error'
    else
      'Unexpected error'
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
