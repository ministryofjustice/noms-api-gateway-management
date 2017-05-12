require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NomsApiGatewayManagement
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.app_title = 'API Gateway Management'
    config.proposition_title = 'API Gateway Management'
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
