class Environment < ApplicationRecord

  before_create :generate_client_keys
  after_create  :generate_jwt
  before_destroy :revoke_all_tokens!

  has_many :tokens, dependent: :nullify
  has_many :access_requests, dependent: :nullify

  validates :name, :provisioning_key, :base_url, presence: true
  validates :name, :provisioning_key, :base_url, uniqueness: true

  validates :provisioning_key, ec_private_key: true

  attr_accessor :pretty_last_checked

  def update_properties!
    if properties_last_checked.nil? || properties_stale?
      client = NomisApiClient.new(self, ExceptionSafeResponseParser.new)
      update_attribute(:health, client.get_health)
      update_attribute(:deployed_version, client.get_version)
      update_attribute(:deployed_version_timestamp, client.get_version_timestamp)
      update_attribute(:properties_last_checked, DateTime.now)
    end
    self.pretty_last_checked = properties_last_checked.strftime("%H:%M")
  end

  private

  def properties_stale?
    properties_last_checked < interval.minutes.ago
  end

  def revoke_all_tokens!
    tokens.each &:revoke!
  end

  def generate_client_keys
    key_group = OpenSSL::PKey::EC::Group.new('prime256v1')
    key = OpenSSL::PKey::EC.new(key_group)
    self.client_private_key = key.generate_key.to_pem

    pub = OpenSSL::PKey::EC.new(key_group)
    pub.public_key = key.public_key
    self.client_pub_key = pub.to_pem
  end

  def generate_jwt
    token = Token.create!(
      requested_by: self.name,
      service_name: 'NOMIS API Gateway Management',
      expires: Date.today + 1.year,
      client_pub_key: self.client_pub_key,
      contact_email: nil,
      environment: self,
      permissions: "^\\/nomisapi\\/version$\n^\\/nomisapi\\/health$",
      created_from: 'management_app'
    )
    self.update_attribute(:jwt, token.provision_and_activate!)
  end
end
