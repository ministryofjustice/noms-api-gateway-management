class EcPrivateKeyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      key = OpenSSL::PKey::EC.new(value)

      # Calling #public_key? returns true for both public and private key,
      # #private_key seems to behave correctly.
      unless key.private_key?
        record.errors[attribute] << (options[:message] || 'is not a EC private key')
      end
    rescue
      record.errors[attribute] << (options[:message] || 'is not a valid EC private key')
    end
  end
end
