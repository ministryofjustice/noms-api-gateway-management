class AccessRequest < ApplicationRecord
  attr_accessor :client_pub_key_file

  validates :requested_by, :contact_email, :reason, :api_env, :client_pub_key_file, presence: :true
  validates :api_env, inclusion: Token::API_ENVS
  validates_email_format_of :contact_email

  before_save :set_client_pub_key

  private

  def set_client_pub_key
    self.client_pub_key = client_pub_key_file.read
  end

end
