class ProvisioningKey < ApplicationRecord
  validates :api_env, :content, presence: true
  validates :api_env, inclusion: ApiEnv.all
  validates :api_env, :content, uniqueness: true

  validates :content, ec_private_key: true
end
