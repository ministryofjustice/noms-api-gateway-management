require 'rails_helper'

RSpec.describe Token, type: :model do
  it_behaves_like 'an EC Public Key validatable'

  it { should validate_presence_of(:requested_by) }
  it { should validate_presence_of(:service_name) }
  it { should validate_presence_of(:api_env) }
  it { should validate_presence_of(:expires) }
  it { should validate_presence_of(:created_from) }
  it { should validate_inclusion_of(:created_from).in_array(Token::CREATED_FROM_VALUES) }
  it { should validate_inclusion_of(:api_env).in_array(ApiEnv.all) }

  context 'when created from the web form' do
    subject{ Token.new(created_from: 'web') }
    
    it { should validate_presence_of(:contact_email) }
    it { should validate_presence_of(:client_pub_key) }
    it { should validate_presence_of(:permissions) }
  end

  context 'when created from the csv import' do
    subject{ Token.new(created_from: 'import') }

    it { should_not validate_presence_of(:contact_email) }
    it { should_not validate_presence_of(:client_pub_key) }
    it { should_not validate_presence_of(:permissions) }
  end

  describe 'scopes' do
    let(:inactive_token) { create(:token) }
    let(:active_token) { create(:token, :active) }
    let(:revoked_token) { create(:token, :revoked) }

    describe '.revoked' do
      it 'returns only the revoked tokens' do
        expect(described_class.revoked).to match_array([revoked_token])
      end
    end

    describe '.unrevoked' do
      it 'returns only the unrevoked tokens' do
        expect(described_class.unrevoked).to match_array([active_token, inactive_token])
      end
    end

    describe '.active' do
      it 'returns only the active tokens' do
        expect(described_class.active).to match_array([active_token])
      end
    end

    describe '.inactive' do
      it 'returns only the unrevoked tokens' do
        expect(described_class.inactive).to match_array([inactive_token])
      end
    end
  end

  describe '#revoke!' do
    let(:active_token) { create(:token, :active) }

    it 'set revoked to true' do
      active_token.revoke!

      expect(active_token).to be_revoked
    end
  end

  describe '#activate!' do
    let(:inactive_token) { create(:token, trackback_token: 'xxxx') }

    before do
      inactive_token.activate!
    end

    it 'sets the trackback_token to nil' do
      expect(inactive_token.trackback_token).to be_nil
    end

    it 'marks the token as active' do
      expect(inactive_token).to be_active
    end
  end

  describe '#provision_and_activate!' do
    let(:inactive_token) { create(:token, trackback_token: 'xxxx') }

    before do
      ProvisioningKey.create(api_env: 'preprod', content: file_fixture('test_provisioner.key').read )
    end

    it 'provisions the token' do
      expect(inactive_token.provision_and_activate!).to_not be_nil
    end

    it 'sets issued_at' do
      inactive_token.provision_and_activate!

      expect(inactive_token.issued_at).to_not be_nil
    end

    it 'sets the fingerprint' do
      inactive_token.provision_and_activate!

      expect(inactive_token.fingerprint).to_not be_nil
    end
  end

  describe 'an unsaved Token' do
    subject { build(:token, trackback_token: nil) }

    describe 'being saved' do
      context 'created_from the web' do
        before{ subject.created_from = 'web' }

        it 'sets the trackback token' do
          expect{ subject.save }.to change(subject, :trackback_token).from(nil)
        end
      end

      context 'created_from import' do
        before{ subject.created_from = 'import' }

        it 'does not set the trackback_token' do
          expect{ subject.trackback_token }.to_not change(subject, :trackback_token)
        end
      end
    end
  end
end
