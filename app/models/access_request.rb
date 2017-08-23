class AccessRequest < ApplicationRecord

  belongs_to :environment

  attr_accessor :client_pub_key_file

  validates :requested_by, :contact_email, :reason, :environment_id, :client_pub_key,
    presence: :true

  validates :client_pub_key, ec_public_key: true
  validates_email_format_of :contact_email

  before_validation :set_client_pub_key

  scope :processed, -> { where(processed: true) }
  scope :unprocessed, -> { where.not(processed: true) }

  def environment_name
    environment ? environment.name : 'Unknown'
  end

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
