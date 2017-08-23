class Environment < ApplicationRecord

  before_destroy :revoke_all_tokens!

  has_many :tokens, dependent: :nullify
  has_many :access_requests, dependent: :nullify

  validates :name, :provisioning_key, presence: true
  validates :name, :provisioning_key, uniqueness: true

  validates :provisioning_key, ec_private_key: true


  private

  def revoke_all_tokens!
    tokens.each &:revoke!
  end
end
