class EcPublicKeyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      key = OpenSSL::PKey::EC.new(value)

      if key.private_key?
        record.errors[attribute] << (options[:message] || 'is not a public key')
      end
    rescue
      record.errors[attribute] << (options[:message] || 'is not a valid EC certificate/key')
    end
  end
end
