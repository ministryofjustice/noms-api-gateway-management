class AccessRequest < ApplicationRecord
  attr_accessor :client_pub_key_file

  validates :requested_by, :contact_email, :reason, :api_env, :client_pub_key,
    presence: :true

  validates :client_pub_key, ec_public_key: true
  validates :api_env, inclusion: Token::API_ENVS
  validates_email_format_of :contact_email

  before_validation :set_client_pub_key

  scope :processed, -> { where(processed: true) }
  scope :unprocessed, -> { where.not(processed: true) }

  def process!
    update_attribute(:processed, true)
  end

  def processed?
    !!processed
  end

  def unprocessed?
    !processed?
  end

  private

  def set_client_pub_key
    self.client_pub_key = self.client_pub_key_file.read if self.client_pub_key_file.present?
  end
end
