class ExceptionSafeResponseParser
  
  attr_accessor :parsed_response, :logger

  def initialize
    self.parsed_response = ParsedResponse.new
    self.logger = Logger.new(STDERR)
  end

  def parse(response)
    parsed_response.code = status_code_for(response)
    parsed_response.data = message_for(response)
    parsed_response
  end

  private

  def status_code_for(response)
    response.is_a?(Exception) ? code_for_exception(response) : response.raw_response.code.to_i
  end

  def code_for_exception(response)
    ResponseErrorAdapter.new(response).code
  end

  def message_for(response)
    response.is_a?(Exception) ? exception_message(response) : normal_message(response)
  end

  def normal_message(response)
    data = response.data
    data.is_a?(Hash) ? data : code_and_data(response)
  end

  def code_and_data(response)
    [ 
      response.raw_response.code, 
      (response.data ? response.data.truncate(30) : nil)
    ].compact.join(': ')
  end

  def exception_message(response)
    logger.level = Logger::ERROR
    logger.error(response)

    ResponseErrorAdapter.new(response).message
  end

  class ParsedResponse
    attr_accessor :code, :data
  end

  class ResponseErrorAdapter
    attr_accessor :code, :message

    def initialize(response)
      code_and_message = self.class.decorate(response)
      self.code = code_and_message[:code]
      self.message = code_and_message[:message]
    end

    protected

    def self.codes_and_messages
      {
        'SocketError'            => {code: 404, message: 'Environment does not exist'},
        'OpenSSL::SSL::SSLError' => {code: 525, message: 'SSL Error'}
      }
    end

    def self.default_error
      {
        message: 'Unexpected error'
      }
    end

    def self.decorate(response)
      codes_and_messages[response.class.name] || default_error
    end
  end

end
