require 'rails_helper'

RSpec.describe Permission, type: :model do

  describe '.flattened' do
    it 'returns a hash' do
      expect( Permission.flattened ).to be_a(Hash)
    end

    describe 'returned Hash' do
      describe 'each key' do
        Permission.flattened.each do |key, val|
          it 'has a string value' do
            expect( val ).to be_a(String)
          end
        end
      end
    end
  end
end