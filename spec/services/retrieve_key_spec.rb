require 'rails_helper'

RSpec.describe RetrieveKey do
  describe '#call' do
    it 'raises an exception when an invalid API env is passed' do
      expect{ described_class.call('foobar') }.to raise_exception(ArgumentError)
    end

    it 'does not raise an exception for a valid env' do
      expect{ described_class.call('prod') }.to_not raise_exception
    end
  end
end
