require 'notifications/client'

module Notify
  module_function

  CLIENT = Notifications::Client.new(Rails.configuration.govuk_notify_api_key)
  ACCESS_REQUEST_NOTIFICATION_TEMPLATE = Rails.configuration.access_request_notification_template
  TOKEN_TRACKBACK_TEMPLATE = Rails.configuration.token_trackback_template
  TEAM_EMAIL = Rails.configuration.team_email

  def service_team(access_request, link)
    email = CLIENT.send_email(
      email_address: TEAM_EMAIL,
      template_id: ACCESS_REQUEST_NOTIFICATION_TEMPLATE,
      personalisation: {
        requester: access_request.requested_by,
        env: access_request.api_env,
        access_request_link: link
      }
    )

    email.id
  end

  def token_trackback(token, link)
    email = CLIENT.send_email(
      email_address: token.contact_email,
      template_id: TOKEN_TRACKBACK_TEMPLATE,
      personalisation: {
        requestor: token.requested_by,
        env: token.api_env,
        trackback_link: link
      }
    )

    email.id
  end
end
