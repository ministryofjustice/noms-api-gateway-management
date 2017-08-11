require 'rails_helper'

RSpec.describe Environment, type: :model do

  subject { create(:environment) }

  it { should validate_presence_of(:name)               }
  it { should validate_presence_of(:provisioning_key)   }
  it { should validate_uniqueness_of(:name)             }
  it { should validate_uniqueness_of(:provisioning_key) }

  it_behaves_like 'an EC Private Key validatable'

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
end
