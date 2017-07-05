Rails.configuration.notify_enabled = ENV.fetch('NOTIFY_ENABLED', 'true').downcase != 'false'

Rails.configuration.govuk_notify_api_key = ENV.fetch('GOVUK_NOTIFY_API_KEY', '')
Rails.configuration.access_request_notification_template = ENV.fetch('ACCESS_REQUEST_NOTIFICATION_TEMPLATE', '8daffa73-f7df-4494-8df5-ce737b52ae86')
Rails.configuration.token_trackback_template = ENV.fetch('TOKEN_TRACKBACK_TEMPLATE', 'e39fd6e3-cdcd-4396-8632-3d733f2653b3')
Rails.configuration.team_email = ENV.fetch('TEAM_EMAIL', 'nomisapi@digital.justice.gov.uk')
