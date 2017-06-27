Rails.configuration.notify_enabled = ENV.fetch('NOTIFY_ENABLED', 'true').downcase != 'false'

if Rails.configuration.notify_enabled {
  Rails.configuration.govuk_notify_api_key = ENV.fetch('GOVUK_NOTIFY_API_KEY', '')
  Rails.configuration.access_request_notification_template = ENV['ACCESS_REQUEST_NOTIFICATION_TEMPLATE']
  Rails.configuration.token_trackback_template = ENV['TOKEN_TRACKBACK_TEMPLATE']
  Rails.configuration.team_email = ENV['TEAM_EMAIL']
}
