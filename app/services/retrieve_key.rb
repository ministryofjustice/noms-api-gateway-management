module RetrieveKey
  module_function

  def call(env)
    raise ArgumentError, "Argument is not a valid env: #{Token::API_ENVS.join(', ')}" unless Token::API_ENVS.include? env

    # Stubbed for testing/prototyping
    File.open("#{Rails.root}/spec/fixtures/test_provisioner.key").read
  end

  class << self
    private

    def decrypt(file)
    end

  end
end
