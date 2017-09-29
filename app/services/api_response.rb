class ApiResponse
  attr_accessor :data, :code

  def initialize(arg)
    if arg.is_a? SocketError
      @data = 'Environment does not exist'
      @code = 404
    else
      @data = arg.data
      @code = arg.raw_response.code.to_i
    end
  end
end
