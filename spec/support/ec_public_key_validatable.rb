shared_examples 'an EC Public Key validatable' do |attribute_name: :client_pub_key|
  let(:ec_public_key_validatable) { build(described_class.to_s.underscore.to_sym) }
  let(:ec_public_key) { fixture_file_upload('test_client.pub', 'text/plain').read }
  let(:ec_private_key) { fixture_file_upload('test_client.key', 'text/plain').read }

  describe 'validation' do
    context 'valid' do
      it 'is valid when the the property is a valid EC public key' do
        ec_public_key_validatable.instance_variable_set("@#{attribute_name}", ec_public_key)
        ec_public_key_validatable.valid?

        expect(ec_public_key_validatable).to be_valid
      end
    end

    context 'invalid' do
      context 'when valid EC key but not a public key' do
        before do
          ec_public_key_validatable.client_pub_key = ec_private_key
          ec_public_key_validatable.valid?
        end

        it 'is a valid EC key but not a public key' do
          expect(ec_public_key_validatable).to_not be_valid
        end

        it 'adds a validation error when not valid' do
          expect(ec_public_key_validatable.errors[attribute_name]).to include('is not a public key')
        end
      end

      context 'when not valid in any way' do
        before do
          ec_public_key_validatable.client_pub_key = 'foobar'
          ec_public_key_validatable.valid?
        end

        it 'is not valid when the the property is not a valid EC public key' do
          expect(ec_public_key_validatable).to_not be_valid
        end

        it 'adds a validation error when not valid' do
          expect(ec_public_key_validatable.errors[attribute_name]).to include('is not a valid EC certificate/key')
        end
      end
    end
  end
end
