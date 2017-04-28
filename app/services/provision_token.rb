module ProvisionToken
  module_function

  ACCESS_POLICY = /.*/

  def call(token:, client_pub:, provisioner_key:)
    private_key_data = provisioner_key.read
    private_key = OpenSSL::PKey::EC.new(private_key_data)
    client_pub_data = client_pub.read
    client_pub = OpenSSL::PKey::EC.new(client_pub_data)

    now = Time.now
    client_token, fingerprint = generate_client_token(
      client_name: token.client_name,
      client_pub_key: client_pub,
      provisioning_pri_key: private_key,
      valid_from: now,
      valid_to: token.expires,
      access: ACCESS_POLICY
    )

    token.update_attribute(:fingerprint, fingerprint)
    token.update_attribute(:issued_at, now)

    client_token
  end

  class << self
    private

    def generate_client_token(client_name:, client_pub_key:, provisioning_pri_key:, valid_from:, valid_to:, access:)
      payload = {
        iat: valid_from.to_i,
        exp: valid_to.to_i,
        client: client_name,
        key: der_in_base64(client_pub_key),
        access: access,
      }

      client_token = JWT.encode(payload, provisioning_pri_key, 'ES256')
      fingerprint = Digest::SHA256.hexdigest(client_token)

      return client_token, fingerprint
    end

    # The DER key encoded as Base64
    def der_in_base64(ec_key)
      Base64.strict_encode64(ec_key.to_der)
    end
  end
end
