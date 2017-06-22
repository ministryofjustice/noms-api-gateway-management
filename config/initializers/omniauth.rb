require 'moj_sso'

Rails.configuration.auth_enabled = ENV.fetch('AUTH_ENABLED', 'true').downcase != 'false'

if Rails.configuration.auth_enabled
  # Localhost SSO config
  app_id = ENV.fetch('MOJSSO_ID')
  app_secret = ENV.fetch('MOJSSO_SECRET')
  sso_url = ENV.fetch('MOJSSO_URL', 'http://localhost:5000') # <- default for localhost
end

unless app_id && app_secret && sso_url
  STDOUT.puts '[WARN] MOJSSO_ID/MOJSSO_SECRET/MOJSSO_URL not configured'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :mojsso, app_id, app_secret, client_options: { site: sso_url }
end
