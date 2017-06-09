require 'notifications/client'

module Notify
  module_function

  CLIENT = Notifications::Client.new(ENV['GOVUK_NOTIFY_API_KEY'])
  ACCESS_REQUEST_NOTIFICATION_TEMPLATE = ENV['ACCESS_REQUEST_NOTIFICATION_TEMPLATE']
  TEAM_EMAIL = ENV['TEAM_EMAIL']

  def service_team(access_request, link)
    email = CLIENT.send_email(
      email_address: TEAM_EMAIL,
      template_id: ACCESS_REQUEST_NOTIFICATION_TEMPLATE,
      personalisation: {
        requestor: access_request.requested_by,
        env: access_request.api_env,
        access_request_link: link
      }
    )

    email.id
  end
end
