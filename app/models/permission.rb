class Permission < ApplicationRecord
  validates :regex, :position,
    presence: true,
    uniqueness: true

  has_many :token_permissions, dependent: :destroy
  has_many :tokens, through: :token_permissions
end
