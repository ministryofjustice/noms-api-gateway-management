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

    it 'is not called on update' do
      expect(subject).not_to receive(:generate_client_keys)
      subject.update(name: 'new_name')
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

    it 'is not called on update' do
      expect(subject).not_to receive(:generate_jwt)
      subject.update(name: 'new_name')
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

  let(:client) do
    double 'NomisApiClient',
    get_health: 'DB Up',
    get_version: '1.0.1',
    get_version_timestamp: '2017-09-14 09:56:36'
  end

  describe '#update_properties!' do
    context 'When an env has just been created' do
      it 'instantiates a NomisApiClient' do
        expect(NomisApiClient).to receive(:new).and_return(client)
        subject.update_properties!
      end

      before { allow(NomisApiClient).to receive(:new).and_return(client) }

      it 'sets #health' do
        subject.update_properties!
        expect(subject.health).to eq 'DB Up'
      end

      it 'sets #deployed_version' do
        subject.update_properties!
        expect(subject.deployed_version).to eq '1.0.1'
      end

      it 'sets #deployed_version_timestamp' do
        subject.update_properties!
        expect(subject.deployed_version_timestamp.to_s).to eq '2017-09-14 09:56:36 +0100'
      end
    end

    context 'When the values for properties are stale' do
      before do
        subject.health = 'Foo'
        subject.deployed_version = '1.0.0'
        subject.deployed_version_timestamp = 1.day.ago
        subject.properties_last_checked = 11.minutes.ago
      end

      it 'instantiates a NomisApiClient' do
        expect(NomisApiClient).to receive(:new).and_return(client)
        subject.update_properties!
      end

      before { allow(NomisApiClient).to receive(:new).and_return(client) }

      it 'sets #health' do
        subject.update_properties!
        expect(subject.health).to eq 'DB Up'
      end

      it 'sets #deployed_version' do
        subject.update_properties!
        expect(subject.deployed_version).to eq '1.0.1'
      end

      it 'sets #deployed_version_timestamp' do
        subject.update_properties!
        expect(subject.deployed_version_timestamp.to_s).to eq '2017-09-14 09:56:36 +0100'
      end
    end

    context 'When the properties have been recently updated' do
      before do
        subject.health = 'Foo'
        subject.deployed_version = '1.0.2'
        subject.deployed_version_timestamp = 1.day.ago
        subject.properties_last_checked = 9.minutes.ago
      end

      it 'does not instantiate a new NomisApiClient' do
        expect(NomisApiClient).not_to receive(:new)
        subject.update_properties!
      end

      before { allow(NomisApiClient).to receive(:new).and_return(client) }

      it 'does not update #health' do
        subject.update_properties!
        expect(subject.health).to eq 'Foo'
      end

      it 'does not change #deployed_version' do
        subject.update_properties!
        expect(subject.deployed_version).to eq '1.0.2'
      end

      it 'does not change #deployed_version_timestamp' do
        subject.update_properties!
        expect(subject.deployed_version_timestamp.to_s).to eq 1.day.ago.to_s
      end
    end
  end
end
