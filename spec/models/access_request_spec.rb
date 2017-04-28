require 'rails_helper'

RSpec.describe AccessRequest, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:reason) }
end
