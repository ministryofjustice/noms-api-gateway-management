require 'rails_helper'

RSpec.describe ProvisioningKey, type: :model do
  it { should validate_presence_of(:api_env) }
  it { should validate_presence_of(:content) }
  it { should validate_inclusion_of(:api_env).in_array(ApiEnv.all) }
  it { should validate_uniqueness_of(:api_env) }
  it { should validate_uniqueness_of(:content) }

  it_behaves_like 'an EC Private Key validatable'
end
