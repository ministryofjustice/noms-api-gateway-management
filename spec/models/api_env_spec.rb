require 'rails_helper'

RSpec.describe ApiEnv, type: :model do
  describe '.all' do
    it 'returns the expected API environments' do
      expect(described_class.all).to eq(['dev', 'preprod', 'prod'])
    end
  end
end
