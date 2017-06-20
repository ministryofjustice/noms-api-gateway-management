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
      ProvisioningKey.create(api_env: 'prod', content: fixture_file_upload('test_provisioner.key', 'text/plain').read)
      expect( described_class.call('prod') ).to eq(fixture_file_upload('test_provisioner.key', 'text/plain').read)
    end

  end
end
