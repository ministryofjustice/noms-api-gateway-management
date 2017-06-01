require 'rails_helper'

RSpec.describe Token, type: :model do
  it { should validate_presence_of(:issued_at) }
  it { should validate_presence_of(:requested_by) }
  it { should validate_presence_of(:service_name) }
  it { should validate_presence_of(:fingerprint) }
  it { should validate_presence_of(:api_env) }
  it { should validate_presence_of(:expires) }
  it { should validate_presence_of(:contact_email) }
  it { should validate_presence_of(:client_pub_key) }

  it { should validate_inclusion_of(:api_env).in_array(Token::API_ENVS) }

  describe 'scopes' do
    let(:unrevoked_token_1) { create(:token) }
    let(:unrevoked_token_2) { create(:token) }
    let(:revoked_token) { create(:token, revoked: true) }

    describe '.revoked' do
      it 'returns only the revoked tokens' do
        expect(described_class.revoked).to match_array([revoked_token])
      end
    end

    describe '.unrevoked' do
      it 'returns only the unrevoked tokens' do
        expect(described_class.unrevoked).to match_array([unrevoked_token_1, unrevoked_token_2])
      end
    end
  end

  describe '#revoke!' do
    let(:unrevoked_token) { create(:token, revoked: false) }

    it 'set revoked to true' do
      unrevoked_token.revoke!

      expect(unrevoked_token).to be_revoked
    end
  end
end
