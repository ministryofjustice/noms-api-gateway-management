class Token < ApplicationRecord
  API_ENVS = %w( dev preprod prod ).freeze
  attr_accessor :client_pub_key

  validates :issued_at, :requested_by, :client_name, :fingerprint, :api_env,
    :expires, :contact_email, :client_pub_key, presence: :true

  validates :api_env, inclusion: Token::API_ENVS

  validates_email_format_of :contact_email

  scope :revoked, -> { where(revoked: true) }
  scope :unrevoked, -> { where.not(revoked: true) }
end
