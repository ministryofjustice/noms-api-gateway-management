require 'rails_helper'

RSpec.describe ProvisionToken do
  let(:permissions_string) do
    "^\/api/allowed/endpoint/one$\n" + "^\/api/allowed/endpoint/two$\n" + "^\/api/allowed/endpoint/three$\n"
  end

  let(:expiration) { 2.years.from_now }

  let(:token) do
    build(:token, service_name: 'foobar', issued_at: nil, expires: expiration, permissions: permissions_string)
  end

  describe '#call' do
    let!(:jwt_token) do
      described_class.call(token: token)
    end

    let!(:decoded_token) { JWT.decode(jwt_token, nil, false) }

    it 'generates a token using the provisioning key and client public key' do
      expect(decoded_token).to_not be_nil
    end

    it "sets the generated token's client name" do
      expect(decoded_token.first['client']).to eq('foobar')
    end

    it "sets the generated token's permissions" do
      expect(decoded_token.first['access']).to eq(permissions_string.split)
    end

    it "sets the generated token's issued at (iat)" do
      expect(decoded_token.first['iat']).to be_within(2).of(Time.now.to_i)
    end

    it "sets the generated token's expiration" do
      expect(decoded_token.first['exp']).to be_within(2).of(expiration.to_i)
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
