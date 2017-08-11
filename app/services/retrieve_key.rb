class ProvisioningKeyNotFoundError < StandardError
end

module RetrieveKey
  module_function


  def call(env)
    raise ArgumentError, "Argument is not a valid env: #{Environment.pluck(:name).join(', ')}" unless Environment.pluck(:name).include? env
    key = Environment.find_by(name: env).provisioning_key
    key
  end

  class << self
    private

    def decrypt(file)
    end

  end
end
