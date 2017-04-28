class Token < ApplicationRecord
  API_ENVS = %w( dev preprod prod )

  validates :issued_at, :requested_by, :client_name, :fingerprint, :api_env,
    :expires, :contact_email, presence: :true
  validates_email_format_of :contact_email
end
