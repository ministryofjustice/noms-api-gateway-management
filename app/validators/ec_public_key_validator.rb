class EcPublicKeyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    regex = /\A-----BEGIN PUBLIC KEY-----.+-----END PUBLIC KEY-----\Z/m

    begin
      OpenSSL::PKey::EC.new(value)

      if value !~ regex
        record.errors[attribute] << (options[:message] || 'is not a public key')
      end
    rescue
      record.errors[attribute] << (options[:message] || 'is not a valid EC certificate/key')
    end
  end
end
