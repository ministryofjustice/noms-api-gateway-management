require 'rails_helper'

RSpec.describe Permission, type: :model do

  subject { create(:permission) }

  it { should validate_presence_of(:regex) }
  it { should validate_presence_of(:position)       }

  it { should validate_uniqueness_of(:regex) }
  it { should validate_uniqueness_of(:position)       }
end
