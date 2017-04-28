require 'rails_helper'

RSpec.describe ProvisionToken do
  let(:test_provisioner_key) { fixture_file_upload('test_provisioner.key', 'text/plain') }
  let(:test_client_pub) { fixture_file_upload('test_client.pub', 'text/plain') }
  let(:token) { build(:token, issued_at: nil, expires: 2.years.from_now) }

  describe '#call' do
    let!(:jwt_token) do
      described_class.call(
        token: token,
        client_pub: test_client_pub,
        provisioner_key: test_provisioner_key
      )
    end

    let!(:decoded_token) { JWT.decode(jwt_token, nil, false) }

    it 'generates a token using the provisioning key and client public key' do
      expect(decoded_token).to_not be_nil
    end

    it "sets the token record's fingerprint" do
      expect(token.fingerprint).to eq(Digest::SHA256.hexdigest(jwt_token))
    end

    it "sets the token record's issued_at" do
      expect(token.issued_at.to_i).to eq(decoded_token[0]['iat'])
    end

    it "sets the token's expiry to the token record's expiry" do
      expect(token.expires.to_i).to eq(decoded_token[0]['exp'])
    end
  end
end
