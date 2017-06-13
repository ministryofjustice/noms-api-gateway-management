class Token < ApplicationRecord
  API_ENVS = %w( dev preprod prod ).freeze
  STATES = %w( inactive active revoked ).freeze

  attr_accessor :client_pub_key_file

  validates :requested_by, :service_name, :api_env, :expires, :contact_email,
    :client_pub_key, presence: :true

  validates :client_pub_key, ec_public_key: true
  validates :api_env, inclusion: Token::API_ENVS
  validates_email_format_of :contact_email

  before_validation :set_client_pub_key
  after_create :set_trackback_token

  scope :inactive, -> { where(state: 'inactive') }
  scope :active, -> { where(state: 'active') }
  scope :revoked, -> { where(state: 'revoked') }
  scope :unrevoked, -> { where.not(state: 'revoked') }

  def revoked?
    state == 'revoked'
  end

  def inactive?
    state == 'inactive'
  end

  def active?
    state == 'active'
  end

  def revoke!
    update_attribute(:state, 'revoked')
  end

  def activate!
    update_attribute(:trackback_token, nil)
    update_attribute(:state, 'active')
  end

  def provision_and_activate!
    output = ProvisionToken.call(token: self)
    activate!
    output
  end

  private

  def set_client_pub_key
    self.client_pub_key = self.client_pub_key_file.read if self.client_pub_key_file.present?
  end

  def set_trackback_token
    update_attribute(:trackback_token, SecureRandom.uuid)
  end
end
