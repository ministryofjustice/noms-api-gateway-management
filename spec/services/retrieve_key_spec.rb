require 'rails_helper'

RSpec.describe RetrieveKey do
  describe '#call' do
    it 'raises an exception when an invalid API env is passed' do
      expect{ described_class.call('foobar') }.to raise_exception(ArgumentError)
    end

    it 'returns the key content for the given API env' do
      create(:environment)
      expect( described_class.call('dev') ).to eq(file_fixture('test_provisioner.key').read)
    end
  end
end
