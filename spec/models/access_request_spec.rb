require 'rails_helper'

RSpec.describe AccessRequest, type: :model do
  it { should validate_presence_of(:contact_email) }
  it { should validate_presence_of(:requested_by) }
  it { should validate_presence_of(:reason) }
  it { should validate_presence_of(:client_pub_key_file) }

  it { should validate_inclusion_of(:api_env).in_array(Token::API_ENVS) }

  describe 'sets the client pub key' do
    let(:client_pub_key_file) { fixture_file_upload('test_client.pub', 'text/plain') }

    subject do
      create(:access_request, client_pub_key_file: client_pub_key_file)
    end

    it 'should set the client public key content' do
      expect(subject.client_pub_key).to eq(File.read(client_pub_key_file))
    end

  end
end
