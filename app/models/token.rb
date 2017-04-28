class Token < ApplicationRecord
  validates :issued_at, :requested_by, :client_name, :fingerprint, :api_env,
    :expires, :contact_email, presence: :true
end
