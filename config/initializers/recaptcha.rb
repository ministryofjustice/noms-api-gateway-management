Rails.configuration.recaptcha_enabled = ENV.fetch('RECAPTCHA_ENABLED', 'true').downcase != 'false'

Rails.configuration.recaptcha_key = ENV.fetch('RECAPTCHA_SITE_KEY', '')
Rails.configuration.recaptcha_secret = ENV.fetch('RECAPTCHA_SECRET_KEY', '')
