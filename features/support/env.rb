FIXTURE_FILES_DIR = File.dirname(__FILE__) + '/../../spec/fixtures/files'
DOMAIN = ENV.fetch('DOMAIN_UNDER_TEST', 'http://localhost:3000')
AUTH_ENABLED = ENV.fetch('AUTH_ENABLED', 'true') == 'true'
if AUTH_ENABLED
  MOJSSO_USER = ENV.fetch('MOJSSO_USER')
  MOJSSO_PASSWORD = ENV.fetch('MOJSSO_PASSWORD')
end
