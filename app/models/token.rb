class Token < ApplicationRecord
  attr_accessor :client_pub_key_file

  validates :issued_at, :requested_by, :service_name, :fingerprint, :api_env,
    :expires, :contact_email, :client_pub_key, presence: :true

  validates :client_pub_key, ec_public_key: true
  validates :api_env, inclusion: ApiEnv.all
  validates_email_format_of :contact_email

  scope :revoked, -> { where(revoked: true) }
  scope :unrevoked, -> { where.not(revoked: true) }

  def revoke!
    update_attribute(:revoked, true)
  end
end
