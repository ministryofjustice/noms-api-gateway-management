require 'notifications/client'

module Notify
  module_function

  def service_team(access_request, link)
    params = {
      requester: access_request.requested_by,
      env: access_request.api_env,
      access_request_link: link
    }

    send_notify_email(Rails.configuration.team_email, Rails.configuration.access_request_notification_template, params)
  end

  def token_trackback(token, link)
    params = {
      requester: token.requested_by,
      env: token.api_env,
      trackback_link: link
    }

    send_notify_email(token.contact_email, Rails.configuration.token_trackback_template, params)
  end

  def reject_access_request(access_request)
    params = {
      requester: access_request.requested_by,
      env: access_request.api_env
    }

    send_notify_email(access_request.contact_email, Rails.configuration.reject_access_request_template)
  end

  def send_notify_email(email_address, template_id, params = {})
    email = client.send_email(
      email_address: email_address,
      template_id: template_id,
      personalisation: params
    )

    email.id
  end

  def client
    Notifications::Client.new(Rails.configuration.govuk_notify_api_key)
  end
end
