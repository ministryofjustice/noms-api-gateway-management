class AccessRequest < ApplicationRecord
  validates :name, :email, :reason, presence: :true
  validates_email_format_of :email
end
