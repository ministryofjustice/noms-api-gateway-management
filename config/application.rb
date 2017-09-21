require_relative 'boot'

require 'rails/all'
require 'rack/throttle'
require 'nomis/api'
require_relative '../app/middleware/access_request_form_throttle'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NomsApiGatewayManagement
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    Rails.configuration.access_request_max_requests_per_minute = ENV.fetch('ACCESS_REQUEST_MAX_REQUESTS_PER_MINUTE', 6)
    config.middleware.use AccessRequestFormThrottle, max: Rails.configuration.access_request_max_requests_per_minute

    config.app_title = 'NOMIS API access'
    config.proposition_title = 'NOMIS API access'
    config.phase = 'alpha'
    config.product_type = 'service'
    config.feedback_url = ''

    config.time_zone = 'London'

    config.generators do |g|
      g.view_specs false
      g.helper_specs false
    end

    ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder
  end
end
