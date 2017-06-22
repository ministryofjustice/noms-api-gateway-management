shared_examples 'an EC Private Key validatable' do |attribute_name: :content|
  let(:ec_private_key_validatable) { build(described_class.to_s.underscore.to_sym) }
  let(:ec_public_key) { file_fixture('test_client.pub').read }
  let(:ec_private_key) { file_fixture('test_client.key').read }

  describe 'validation' do
    context 'when the the property is a valid EC private key' do
      it 'is valid' do
        ec_private_key_validatable.content = ec_private_key
        ec_private_key_validatable.valid?

        expect(ec_private_key_validatable).to be_valid
      end
    end

    context 'when the the property is not a valid EC private key' do
      context 'is public EC key' do
        before do
          ec_private_key_validatable.content = ec_public_key
          ec_private_key_validatable.valid?
        end

        it 'is a valid EC key but not a private key' do
          expect(ec_private_key_validatable).to_not be_valid
        end

        it 'adds a validation error when not valid' do
          expect(ec_private_key_validatable.errors[attribute_name]).to include('is not a EC private key')
        end
      end

      context 'is not valid' do
        before do
          ec_private_key_validatable.content = 'foobar'
          ec_private_key_validatable.valid?
        end

        it 'is not valid when the the property is not a valid EC private key' do
          expect(ec_private_key_validatable).to_not be_valid
        end

        it 'adds a validation error when not valid' do
          expect(ec_private_key_validatable.errors[attribute_name]).to include('is not a valid EC private key')
        end
      end
    end
  end
end
