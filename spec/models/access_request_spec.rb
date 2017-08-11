require 'rails_helper'

RSpec.describe AccessRequest, type: :model do
  it_behaves_like 'an EC Public Key validatable'

  subject { create(:access_request) }

  it { should validate_presence_of(:contact_email) }
  it { should validate_presence_of(:requested_by) }
  it { should validate_presence_of(:reason) }
  it { should validate_presence_of(:client_pub_key) }

  describe 'sets the client pub key' do
    let(:client_pub_key_file) { file_fixture('test_client.pub') }

    subject do
      create(:access_request, client_pub_key_file: client_pub_key_file)
    end

    it 'should set the client public key content' do
      expect(subject.client_pub_key).to eq(File.read(client_pub_key_file))
    end
  end

  describe '#environment_name' do
    context 'when environment is present' do
      it 'returns the environment name' do
        expect(subject.environment_name).to eq 'dev'
      end
    end

    context 'when environment has been nullified' do
      before { subject.environment_id = nil }
      it 'returns "Unknown"' do
        expect(subject.environment_name).to eq 'Unknown'
      end
    end
  end

  describe '#process!' do
    it 'sets the access request to processed' do
      subject.process!
      expect(subject).to be_processed
    end
  end

  describe '#unprocessed?' do
    it 'check if the access request is unprocessed' do
      expect(subject).to be_unprocessed
    end
  end

  describe '#proceesed?' do
    it 'checks if the access request is processed' do
      subject.process!
      expect(subject).to be_processed
    end
  end
end
