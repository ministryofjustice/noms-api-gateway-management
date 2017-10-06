class ExceptionSafeResponse
  attr_accessor :data, :code

  def initialize(payload)
    if payload.is_a? SocketError
      @data = 'Environment does not exist'
      @code = 404
    else
      @data = payload.data
      @code = payload.raw_response.code.to_i
    end
  end
end
