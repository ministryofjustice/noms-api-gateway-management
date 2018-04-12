Rails.configuration.auth_enabled = ENV.fetch('AUTH_ENABLED', 'true').downcase != 'false'

# if Rails.configuration.auth_enabled
#   # Localhost SSO config
#   app_id = ENV.fetch('MOJSSO_ID')
#   app_secret = ENV.fetch('MOJSSO_SECRET')
#   sso_url = ENV.fetch('MOJSSO_URL', 'http://localhost:5000') # <- default for localhost
# end

# unless app_id && app_secret && sso_url
#   STDOUT.puts '[WARN] MOJSSO_ID/MOJSSO_SECRET/MOJSSO_URL not configured'
# end

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :mojsso, app_id, app_secret, client_options: { site: sso_url }
# end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    'GSgr7pR73IE4gwXDWKty0ZtyiUZPf3kN',
    'hM6b9CWmlylwwzv1OCUeKKRXNe3orpf8r_xcKQGMpjflcv2QlbXuu23nQ_8ixqzD',
    'moj-dev.eu.auth0.com',
    callback_path: "/auth/oauth2/callback",
    authorize_params: {
      scope: 'openid profile',
      audience: 'https://moj-dev.eu.auth0.com/userinfo'
    }
  )
end
