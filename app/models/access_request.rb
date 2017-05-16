class AccessRequest < ApplicationRecord
  attr_accessor :client_pub_key_file
  attr_accessor :pgp_key_file

  validates :name, :email, :reason, :api_env, :client_pub_key_file, :pgp_key_file, presence: :true
  validates :api_env, inclusion: Token::API_ENVS
  validates_email_format_of :email

  before_save :set_pgp_key, :set_client_pub_key

  private

  def set_client_pub_key
    self.client_pub_key = client_pub_key_file.read
  end

  def set_pgp_key
    self.pgp_key = pgp_key_file.read
  end
end
