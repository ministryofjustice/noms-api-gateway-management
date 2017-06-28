Rails.configuration.notify_enabled = ENV.fetch('NOTIFY_ENABLED', 'true').downcase != 'false'

Rails.configuration.govuk_notify_api_key = ENV.fetch('GOVUK_NOTIFY_API_KEY', '')
Rails.configuration.access_request_notification_template = ENV.fetch('ACCESS_REQUEST_NOTIFICATION_TEMPLATE', '')
Rails.configuration.token_trackback_template = ENV.fetch('TOKEN_TRACKBACK_TEMPLATE', '')
Rails.configuration.team_email = ENV.fetch('TEAM_EMAIL', '')
