class Token < ApplicationRecord

  belongs_to :environment

  CREATED_FROM_VALUES = ['web','import', 'management_app']

  attr_accessor :client_pub_key_file

  validates :requested_by, :service_name, :expires, :created_from,
            presence: :true
  validates :client_pub_key, presence: true, ec_public_key: true, if: :from_web?
  validates :environment,    presence: true, unless: :revoked?
  validates :permissions,    presence: true, if: :from_web?
  validates :contact_email,  presence: true, if: :from_web?
  validates_email_format_of  :contact_email, if: :from_web?

  validates :created_from, inclusion: Token::CREATED_FROM_VALUES

  before_validation :set_client_pub_key
  after_create :set_trackback_token, unless: :from_import?

  scope :inactive, -> { where(state: 'inactive') }
  scope :active, -> { where(state: 'active') }
  scope :revoked, -> { where(state: 'revoked') }
  scope :unrevoked, -> { where.not(state: 'revoked') }

  def environment_name
    environment ? environment.name : 'Unknown'
  end

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

  def from_web?
    created_from == 'web'
  end

  def from_import?
    created_from == 'import'
  end

  def from_management_app?
    created_from == 'management_app'
  end

  private

  def set_client_pub_key
    if self.client_pub_key_file.present?
      self.client_pub_key = self.client_pub_key_file.read
    end
  end

  def set_trackback_token
    update_attribute(:trackback_token, SecureRandom.uuid)
  end
end
