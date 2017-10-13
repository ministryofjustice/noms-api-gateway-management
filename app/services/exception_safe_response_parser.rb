class ExceptionSafeResponseParser
  
  attr_accessor :parsed_response, :logger

  def initialize
    @parsed_response = ParsedResponse.new(code: nil, data: nil)
  end

  def parse(response)
    parsed_response.parse!(response)
  end

  private

  class ParsedResponse
    attr_accessor :code, :data, :logger

    def initialize(attrs = {})
      self.code = attrs[:code]
      self.data = attrs[:data]
      self.logger = Logger.new(STDERR)
    end

    def parse!(response)
      self.code = status_code_for(response)
      self.data = message_for(response)
      self
    end

    protected

    def message_for(response)
      response.is_a?(Exception) ? exception_message(response) : parse_data(response.data)
    end

    def parse_data(data)
      data.is_a?(Hash) ? data : "#{self.code}#{': ' + data.truncate(30) if data }"
    end

    def exception_message(response)
      logger.level = Logger::ERROR
      logger.error(response)

      ResponseErrorAdapter.new(response).message
    end

    def status_code_for(response)
      response.is_a?(Exception) ? code_for_exception(response) : response.raw_response.code.to_i
    end

    def code_for_exception(response)
      ResponseErrorAdapter.new(response).code
    end
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
