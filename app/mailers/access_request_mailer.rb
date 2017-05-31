class AccessRequestMailer < ApplicationMailer
  def access_request_email(access_request)
    @access_request = access_request
    # mail(to: XXXXXXX, subject: 'New access request')
  end
end
