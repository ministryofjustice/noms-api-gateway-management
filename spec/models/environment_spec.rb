require 'rails_helper'

RSpec.describe Environment, type: :model do

  subject            { create(:environment)                                                }
  let(:key_group)    { OpenSSL::PKey::EC::Group.new('prime256v1')                          }
  

  it { should validate_presence_of(:name)                 }
  it { should validate_presence_of(:provisioning_key)     }
  it { should validate_presence_of(:base_url)             }
  it { should validate_uniqueness_of(:name)               }
  it { should validate_uniqueness_of(:provisioning_key)   }
  it { should validate_uniqueness_of(:base_url)           }

  it_behaves_like 'an EC Private Key validatable'

  describe '#generate_client_keys' do
    it 'is called before_create' do
      subject = build(:environment)
      expect(subject).to receive(:generate_client_keys)
      allow(subject).to receive(:generate_jwt)
      subject.save
    end

    it 'sets the client keys' do
      subject = build(:environment)
      expect(subject.client_pub_key).to be_nil
      expect(subject.client_private_key).to be_nil
      subject.save
      expect(subject.client_pub_key).not_to be_nil
      expect(subject.client_private_key).not_to be_nil
    end
  end

  describe '#generate_jwt' do
    it 'is called after_create' do
      subject = build(:environment)
      expect(subject).to receive(:generate_jwt)
      subject.save
    end

    it 'sets the jwt' do
      subject = build(:environment)
      expect(subject.jwt).to be_nil
      subject.save
      expect(subject.jwt).not_to be_nil
    end
  end

  describe '#revoke_all_tokens!' do
    it 'is called before_destroy' do
      expect(subject).to receive(:revoke_all_tokens!)
      subject.destroy
    end

    it 'revokes all dependent tokens' do
      token_one = create(:token, :active, environment: subject)
      token_two = create(:token, :active, environment: subject)
      subject.destroy
      expect(token_one.reload).to be_revoked
      expect(token_one.environment_id).to be_nil
      expect(token_two.reload).to be_revoked
      expect(token_two.environment_id).to be_nil
    end
  end

  describe '#health' do
    it 'delegates to NomisApiClient#get_health' do
      expect_any_instance_of(NomisApiClient).to receive(:get_health)
      subject.health
    end
  end

  describe '#deployed_version' do
    it 'delegates to NomisApiClient#get_version' do
      expect_any_instance_of(NomisApiClient).to receive(:get_version)
      subject.deployed_version
    end
  end

  describe '#deployed_version_timestamp' do
    it 'delegates to NomisApiClient#get_version_timestamp' do
      expect_any_instance_of(NomisApiClient).to receive(:get_version_timestamp)
      subject.deployed_version_timestamp
    end
  end
end
