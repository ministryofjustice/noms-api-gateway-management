class Permission < ApplicationRecord
  validates :regex, :position,
    presence: true,
    uniqueness: true

    # has_and_belongs_to_many :tokens
end
