class ProvisioningKeyNotFoundError < StandardError
end

module RetrieveKey
  module_function


  def call(env)
    raise ArgumentError, "Argument is not a valid env: #{ApiEnv.all.join(', ')}" unless ApiEnv.all.include? env

    key = ProvisioningKey.find_by(api_env: env)
    raise ProvisioningKeyNotFoundError, "Provisioning key not found for api_env: #{env}" unless key

    key.content
  end

  class << self
    private

    def decrypt(file)
    end

  end
end
