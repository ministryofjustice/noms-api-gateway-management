require 'rails_helper'

RSpec.describe RetrieveKey do
  describe '#call' do
    it 'raises an exception when an invalid API env is passed' do
      expect{ described_class.call('foobar') }.to raise_exception(ArgumentError)
    end

    it 'raises an exception when the key does not exist' do
      expect{ described_class.call('prod') }.to raise_exception(ProvisioningKeyNotFoundError)
    end

    it 'returns the key content for the given API env' do
      ProvisioningKey.create(api_env: 'prod', content: file_fixture('test_provisioner.key').read)
      expect( described_class.call('prod') ).to eq(file_fixture('test_provisioner.key').read)
    end

  end
end
