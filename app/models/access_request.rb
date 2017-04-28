class AccessRequest < ApplicationRecord
  validates :name, :email, :reason, presence: :true
end
