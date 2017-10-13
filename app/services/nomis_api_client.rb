class NomisApiClient

  attr_reader :env_name, :client_key, :client_token,
    :base_url, :parser

  def initialize(env, exception_safe_parser)
    @env_name     = env.name
    @client_key   = env.client_private_key
    @client_token = env.jwt
    @base_url     = env.base_url
    @parser       = exception_safe_parser
  end

  def get_health
    get('health').data
  end

  def get_version
    get('version').data['api-version']
  end

  def get_version_timestamp
    get('version').data['build-timestamp']
  end

  def get(path)
    begin
      parser.parse(NOMIS::API::Get.new(
        client_key: client_key,
        client_token: client_token,
        base_url: base_url,
        path: path
      ).execute)
    rescue => exception
      parser.parse(exception)
    end
  end
end
