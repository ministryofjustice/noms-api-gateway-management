class NomisApiClient

  attr_reader :env_name, :client_key, :client_token

  def initialize(env)
    @env_name = env.name
    @client_key = env.client_private_key
    @client_token = env.jwt
  end

  def base_url
    if env_name == 'prod'
      "https://noms-api.service.justice.gov.uk/nomisapi/"
    else
      "https://noms-api-#{env_name}.dsd.io/nomisapi/"
    end
  end

  def get_health
    response = get('health')
    if response.raw_response.code == '200'
      response.data
    else
      "ERROR #{response.raw_response.code}"
    end
  end

  def get_version
    get('version').data['api-version']
  end

  def get_version_timestamp
    get('version').data['build-timestamp']
  end

  def get(path)
    NOMIS::API::Get.new(
      client_key: client_key,
      client_token: client_token,
      base_url: base_url,
      path: path
    ).execute
  end
end