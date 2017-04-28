require 'rails_helper'

RSpec.describe Token, type: :model do
  it { should validate_presence_of(:issued_at) }
  it { should validate_presence_of(:requested_by) }
  it { should validate_presence_of(:client_name) }
  it { should validate_presence_of(:fingerprint) }
  it { should validate_presence_of(:api_env) }
  it { should validate_presence_of(:expires) }
  it { should validate_presence_of(:contact_email) }
end
